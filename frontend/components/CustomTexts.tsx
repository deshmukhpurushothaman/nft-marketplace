'use client';
import { motion } from "framer-motion";
import { textContainer, textVariant2 } from "../utils/motion";

export const TypingText = ({ title, textStyles }: any) => {
    return (
        <motion.p
            variants={textContainer}
            className={`font-normal text-[14px] text-secondary-white ${textStyles}`}
        >
            {Array.from(title).map((letter: any, index: any) => (
                (
                    <motion.span variants={textVariant2} key={index}>
                        {letter === '' ? '\u00A0' : letter}
                    </motion.span>
                )))}
        </motion.p>)
}

export const TitleText = ({ title, textStyles }: any) => {

}