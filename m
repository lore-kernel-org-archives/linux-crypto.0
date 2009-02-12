From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Crypto] 2.6.29-rc4-git4 build failure
 crypto/async_tx/async_xor
Date: Thu, 12 Feb 2009 13:43:31 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902121340460.29413@vixen.sonytel.be>
References: <4993CA04.60207@in.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Shannon Nelson <shannon.nelson@intel.com>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63172 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760217AbZBLMnq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Feb 2009 07:43:46 -0500
In-Reply-To: <4993CA04.60207@in.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 12 Feb 2009, Sachin P. Sant wrote:
> On a powerpc box 2.6.29-rc4-git4 randconfig build fails with :
>=20
>  CC [M]  crypto/async_tx/async_xor.o
> crypto/async_tx/async_xor.c: In function async_xor_init:
> crypto/async_tx/async_xor.c:313: error: size of array type name is ne=
gative
> make[2]: *** [crypto/async_tx/async_xor.o] Error 1
> make[1]: *** [crypto/async_tx] Error 2
> make: *** [crypto] Error 2

| static int __init async_xor_init(void)
| {
| 	#ifdef CONFIG_DMA_ENGINE
| 	/* To conserve stack space the input src_list (array of page pointer=
s)
| 	 * is reused to hold the array of dma addresses passed to the driver=
=2E
| 	 * This conversion is only possible when dma_addr_t is less than the
| 	 * the size of a pointer.  HIGHMEM64G is known to violate this
| 	 * assumption.
| 	 */
| 	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
| 	#endif
|=20
| 	return 0;
| }

Of course. This will fail on any 32-bit platform with a physical addres=
s space
larger than 32-bit (PPC44x, several MIPSes, ...).

The offending commit is:

commit 0036731c88fdb5bf4f04a796a30b5e445fc57f54
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Feb 2 19:49:57 2008 -0700

    async_tx: kill tx_set_src and tx_set_dest methods
   =20
    The tx_set_src and tx_set_dest methods were originally implemented =
to allow
    an array of addresses to be passed down from async_xor to the dmaen=
gine
    driver while minimizing stack overhead.  Removing these methods all=
ows
    drivers to have all transaction parameters available at 'prep' time=
, saves
    two function pointers in struct dma_async_tx_descriptor, and reduce=
s the
    number of indirect branches..
   =20
    A consequence of moving this data to the 'prep' routine is that
    multi-source routines like async_xor need temporary storage to conv=
ert an
    array of linear addresses into an array of dma addresses.  In order=
 to keep
    the same stack footprint of the previous implementation the input a=
rray is
    reused as storage for the dma addresses.  This requires that
    sizeof(dma_addr_t) be less than or equal to sizeof(void *).  As a
    consequence CONFIG_DMADEVICES now depends on !CONFIG_HIGHMEM64G.  I=
t also
    requires that drivers be able to make descriptor resources availabl=
e when
    the 'prep' routine is polled.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Shannon Nelson <shannon.nelson@intel.com>

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
