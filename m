From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [RFC v1.1 1/5] crypto: GnuPG based MPI lib
Date: Wed, 17 Aug 2011 15:23:05 +0300
Message-ID: <4E4BB2A9.30508@intel.com>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com>	<b1b21a68321fa5fc79295a28e4560391606b043e.1313082284.git.dmitry.kasatkin@intel.com>	<4E49456A.4020506@intel.com> <CAJU7zaKYRLO1yfNBZOho6LSczYr+PPvHT7zfmo=kSoVcM=O2ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:59513 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752126Ab1HQMVy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:21:54 -0400
In-Reply-To: <CAJU7zaKYRLO1yfNBZOho6LSczYr+PPvHT7zfmo=kSoVcM=O2ng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 17/08/11 14:38, Nikos Mavrogiannopoulos wrote:
> On Mon, Aug 15, 2011 at 6:12 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
>> On 11/08/11 20:20, Dmitry Kasatkin wrote:
>>> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
>>>
>>> Adds the multi-precision-integer maths library which was originally taken
>>> from GnuPG and ported to the kernel by (among others) David Howells.
>>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>>> This library is used to implemenet RSA digital signature verification
>>> used in IMA/EVM integrity protection subsystem.
> Was there a particular reason to select the GnuPG mpi lib? Why not
> include gmp (the gnupg mpi lib is a very old fork of gmp), or some other
> big number library?
>
GNUPG MPI kernel port was available and has shown the best performance
comparing to other kernel implementations
such as LibTomMath and once other rsa implementation..

In fact I took libtommath from your cryptodev-linux#newapi project.
I have patches and RSA implementation in my git trees.
IIRC performance was about twice worse than in Gnupg MPI lib...

- Dmitry



- Dmitry

> regards,
> Nikos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
