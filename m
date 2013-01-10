From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Thu, 10 Jan 2013 12:08:01 -0800
Message-ID: <1357848481.17632.140.camel@schen9-DESK>
References: <50EED427.2040309@xyratex.com>  <50EED643.2010907@xyratex.com>
	 <1357840496.17632.119.camel@schen9-DESK>  <50EF15E0.5060204@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Dilger <adilger@whamcloud.com>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3AJUID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 15:08:03 -0500
In-Reply-To: <50EF15E0.5060204@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2013-01-10 at 23:26 +0400, Alexander Boyko wrote:
> 1/10/13 9:54 PM, Tim Chen =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >
> > On Thu, 2013-01-10 at 18:54 +0400, Alexander Boyko wrote:
> >> From: Alexander Boyko <alexander_boyko@xyratex.com>
> >>
> >> This patch adds crc32 algorithms to shash crypto api. One is wrapp=
er to
> >> gerneric crc32_le function. Second is crc32 pclmulqdq implementati=
on. It
> >> use hardware provided PCLMULQDQ instruction to accelerate the CRC3=
2 disposal.
> >> This instruction present from Intel Westmere and AMD Bulldozer CPU=
s.
> >>
> >> For intel core i5 I got 450MB/s for table implementation and 2100M=
B/s=20
> >> for pclmulqdq implementation (
> > Alexander,
> >
> > Wonder if you have a chance to test performance of our PCLMULQDQ
> > implementation for crc32c that's in the current code (see
> > crc32c-pcl-intel-asm_64.asm). The throughput will probably be compa=
rable
> > with your implementation.
> >
> > Tim
> >
> >
> >
> I have no chance to test crc32c pclmul, but I tested previous crc32c
> implementation on crc32 instruction, the speed was about 2500 MB/s. S=
o,
> I think, the newest version should be faster.

It will be troublesome to maintain two separate versions of PCLMUL
crc32c code.  So we should find out if there's performance benefit of
your PCLMUL code over the one in the codebase.  Testing should be
straight forward by enabling the CRYPTO_CRC32C_INTEL option in kernel
and inserting the crc32c-intel module.  =20

You may also want to add check in your glue code for support of the
PCLMUL feature before calling the pclmul version.  You probably also
don't want to use this feature if the data size is small, as
kernel_fpu_begin and kernel_fpu_end takes significant time.  In that
case, using the crc32c hw instructions in a loop is faster (see
crc32c-intel_glue.c).

Tim
