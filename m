From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: arch_random_refill
Date: Sun, 11 May 2014 20:44:03 -0700
Message-ID: <53704383.8060504@linux.intel.com>
References: <21542339.0lFnPSyGRS@myon.chronox.de> <53703E74.9020700@linux.intel.com> <3260147.sUis3H5ONm@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3260147.sUis3H5ONm@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/11/2014 08:36 PM, Stephan Mueller wrote:
> 
> Ohh, ok, thanks for fixing that. :-) 
> 
> Though what makes me wonder is the following: why are some RNGs forced to use 
> the hw_random framework whereas some others are not? What is the driver for 
> that?
> 
> The current state of random.c vs. drivers/char/hw_random and the strong in-
> kernel separation between both makes me wonder. Isn't that all kind of 
> inconsistent?
> 

The main differences are speed of access, trivial interface, and
architectural guarantees.  You also don't have to deal with enumeration,
DMA engines, interrupts, indirect access, or bus drivers, which all are
utterly unacceptable on a synchronous path.

That being said, it is getting clear that we most likely would be better
off with the kernel directly feeding from at least a subset of the
hw_random drivers, rather than waiting for user space to come along and
launch a daemon... after $DEITY knows how many other processes have
already been launched.  There are patches being worked on to make that
happen, although there are a fair number of potential issues, including
the fact that some of the hw_random drivers are believed to be dodgy --
for example, the TPM driver: some TPMs are believed to not contain any
entropy element and simply rely on a factory-seeded nonvolatile counter
(since the TPM has to have support for nonvolatile counters anyway, this
hardware is already present.)

	-hpa
