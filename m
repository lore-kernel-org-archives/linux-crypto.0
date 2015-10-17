From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sat, 17 Oct 2015 15:11:37 +0100
Message-ID: <20151017141137.GN32532@n2100.arm.linux.org.uk>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
 <20151017094300.GL32532@n2100.arm.linux.org.uk>
 <20151017065744.8ef86a4edd0de0084ed8e5c6@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, fabio.estevam@freescale.com,
	boris.brezillon@free-electrons.com, arno@natisbad.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	davem@davemloft.net
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42922 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbJQOLq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 10:11:46 -0400
Content-Disposition: inline
In-Reply-To: <20151017065744.8ef86a4edd0de0084ed8e5c6@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 17, 2015 at 06:57:44AM -0700, Victoria Milhoan wrote:
> Correct - this was apparently the wrong patch I pushed out. The one I'm
> actively using has this fixed (this is the only difference). I will make
> this change in v2 after reviewing your other comments.

Thanks Victoria, but please perform the tests I've suggested in one of
my previous emails - merely testing with openssl's built-in tests aren't
sufficient.  Also, openssl is non-obvious with what it's testing,
especially if you're using "openssl speed".  I'm afraid it's a case of
"you don't know what's being tested unless you've read the openssl
source" :(

However, while trying to debug the DECO stuff, I've stumbled across this:

static inline void append_ptr(u32 *desc, dma_addr_t ptr)
{
        dma_addr_t *offset = (dma_addr_t *)desc_end(desc);

        *offset = ptr;

        (*desc) += CAAM_PTR_SZ / CAAM_CMD_SZ;
}

where I think 'desc' points to memory used for the descriptor, which is
read by hardware, correct?

If that's true, why are we using dma_addr_t here?  dma_addr_t can be
either 32-bit or 64-bit depending on the kernel configuration, and I
suspect if this driver is built with dma_addr_t set to 64-bit, things
will go awry.

Also, what endianness are the hardware descriptors?  Are they always
native CPU endian, or are they fixed as little endian?  If they're always
little endian, is there any reason not to use __le32 and cpu_to_le32()/
le32_to_cpu() as appropriate to ensure that it works on big endian
systems?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
