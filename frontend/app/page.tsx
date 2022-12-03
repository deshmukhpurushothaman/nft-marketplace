import Navbar from '../components/Navbar'
import About from '../sections/About';
import Hero from '../sections/Hero';

const Page = () => {
    return (
        <div className='bg-primary-black overflow-hidden' >
            <Navbar />
            <Hero />
            <div className="relative">
                <About />
                <div className="gradient-03 z-0" />
                {/* < Explore /> */}
            </div>
            {/* <div className="relative">
                <GetStarted />
                <div className="gradient-04 z-0" />
                < WhatsNew />
            </div> */}
            {/* <World /> */}
            {/* <div className="relative">
                <Insights />
                <div className="gradient-04 z-0" />
                < Feedback />
            </div> */}
            {/*
            < Footer /> */}
        </div>
    )
};

export default Page;
