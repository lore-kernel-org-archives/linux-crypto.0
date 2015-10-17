From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] crypto: caam - Add support for hashing export and import
 functions
Date: Sat, 17 Oct 2015 18:36:36 +0100
Message-ID: <20151017173636.GO32532@n2100.arm.linux.org.uk>
References: <1445037573-29667-1-git-send-email-vicki.milhoan@freescale.com>
 <20151017105254.GM32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, fabio.estevam@freescale.com,
	boris.brezillon@free-electrons.com, arno@natisbad.org,
	thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
	davem@davemloft.net
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43294 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbbJQRgs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 13:36:48 -0400
Content-Disposition: inline
In-Reply-To: <20151017105254.GM32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 17, 2015 at 11:52:54AM +0100, Russell King - ARM Linux wrote:
> Now, with that change, and with your change to buf_0/buf_1, I see
> (before the import/export functions are used) several of these errors:
> 
> caam_jr 2101000.jr0: 40000501: DECO: desc idx 5: SGT Length Error. The descriptor is trying to read more data than is contained in the SGT table.
> 
> when checking using openssh.  They don't occur when testing with openssl
> performing normal hashes (as per my previously posted script) but only
> with openssh.

The hardware seems to be quite justified in complaining - I've added code
to dump out the scatter list as well:

jobdesc@879: e4bd7c18: b0861c08 3cd29080 f1400000 34bd7c38  .......<..@.8|.4
jobdesc@879: e4bd7c28: 00000068 f8400000 3ccf3640 00000028  h.....@.@6.<(...
sg@882: e4bd7c38: 00000000 3ccf3640 00000028 00000000
sg@882: e4bd7c48: 00000000 34bd7300 00000006 00000000
sg@882: e4bd7c58: 00000000 7528a070 40000020 00000000

If I'm interpreting this correctly:

	f1400000 34bd7c38 00000068

tells the CAAM to read 0x68 bytes using the scatterlist at 0x34bd7c38.

The scatterlist here contains three entries, which have lengths 0x28,
0x6 and 0x20, which total up to 0x4e bytes, not 0x68.

Now, looking at how the scatterlist is created, I have yet more questions.

1. What's this dma_map_sg_chained() and dma_unmap_sg_chained() stuff?
   What's wrong with just calling dma_map_sg() on the scatterlist, giving
   it the number of entries we want to map?  dma_map_sg() is supposed to
   deal with chained scatterlists, if it doesn't, it's buggy.

2. src_map_to_sec4_sg() fails to check whether dma_map_sg_chained() failed.
   if it failed, we continue anyway, poking invalid addresses into the
   hardware scatterlist, thereby causing memory corruption.

3. __sg_count() - what's going on with this.  This seems to assume that
   scatterlists aren't chained as:

                if (!sg_is_last(sg) && (sg + 1)->length == 0)

   sg + 1 may _not_ be sg_next(sg) - and this will walk off the end of
   the array.

4. Is the try_buf_map_to_sec4_sg() call correct?  Shouldn't it be:

@@ -838,7 +838,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		state->buf_dma = try_buf_map_to_sec4_sg(jrdev,
 							edesc->sec4_sg + 1,
 							buf, state->buf_dma,
-							*next_buflen, *buflen);
+							*buflen, last_buflen);
 
 		if (src_nents) {
  			src_map_to_sec4_sg(jrdev, req->src, src_nents,

   Indeed, with this change, my ssh test works, and the DECO errors are
   gone.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
