From: Stephan Mueller <smueller@chronox.de>
Subject: [ANNOUNCE] /dev/random - a new approach code for 4.9-rc1
Date: Sun, 23 Oct 2016 01:54:23 +0200
Message-ID: <3165606.PaOa21LjIP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

The patch set that can be downloaded at [1] provides a different approach to /
dev/random which I call Linux Random Number Generator (LRNG) to collect 
entropy within the Linux kernel. The main improvements compared to the legacy 
/dev/random is to provide sufficient entropy during boot time as well as in 
virtual environments and when using SSDs or Device Mapper targets. A secondary 
design goal is to limit the impact of the entropy collection on massive 
parallel systems and also allow the use accelerated cryptographic primitives. 
Also, all steps of the entropic data processing are testable. Finally 
performance improvements are visible at /dev/urandom and get_random_bytes.

The design and implementation is driven by a set of goals described in [2]
that the LRNG completely implements. Furthermore, [2] includes a
comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
AIS20/31.

[1] http://www.chronox.de/lrng.html

[2] http://www.chronox.de/lrng/doc/lrng.pdf

Ciao
Stephan
