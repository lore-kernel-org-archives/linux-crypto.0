From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH Resend 0/5] hwrng: stm32 - Improvement for stm32-rng
Date: Sat, 3 Mar 2018 00:34:00 +0800
Message-ID: <20180302163359.GB21579@gondor.apana.org.au>
References: <20180215130312.23612-1-lionel.debieve@st.com>
 <20180222140328.GE28447@gondor.apana.org.au>
 <8dcbcea1-78f7-27ff-66a0-a6180d32a05e@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lionel Debieve <lionel.debieve@st.com>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <rob.herring@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Alexandre Torgue <alexandre.torgue@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8dcbcea1-78f7-27ff-66a0-a6180d32a05e@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 22, 2018 at 04:25:46PM +0100, Alexandre Torgue wrote:
> Hi
> 
> On 02/22/2018 03:03 PM, Herbert Xu wrote:
> >On Thu, Feb 15, 2018 at 02:03:07PM +0100, Lionel Debieve wrote:
> >>This set of patches add extended functionalities for stm32 rng
> >>driver.
> >>Patch #1 includes a reset during probe to avoid any error status
> >>which can occur during bootup process and keep safe rng integrity.
> >>
> >>Patch #3 adds a new property to manage the clock error detection
> >>feature which can be disabled on specific target.
> >>
> >>Patch #5 rework the timeout calculation for read value that was
> >>previously defined based on loop operation and is now based on
> >>timer.
> >
> >I should take only patches 1/3/5, right?
> 
> You could take all (dt-bindings + drivers part).

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
