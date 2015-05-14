From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: nx - add hardware 842 crypto comp alg
Date: Thu, 14 May 2015 13:09:44 +0300
Message-ID: <20150514100944.GA19879@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46832 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758AbbENKKA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 May 2015 06:10:00 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Dan Streetman,

This is a semi-automatic email about new static checker warnings.

The patch ed70b479c2c0: "crypto: nx - add hardware 842 crypto comp
alg" from May 7, 2015, leads to the following Smatch complaint:

drivers/crypto/nx/nx-842-crypto.c:301 nx842_crypto_compress()
	 warn: variable dereferenced before check 'tfm' (see line 292)

drivers/crypto/nx/nx-842-crypto.c
   288  static int nx842_crypto_compress(struct crypto_tfm *tfm,
   289                                   const u8 *src, unsigned int slen,
   290                                   u8 *dst, unsigned int *dlen)
   291	{
   292		struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
                                                              ^^^
Dereference.

   293		struct nx842_crypto_header *hdr = &ctx->header;
   294		struct nx842_crypto_param p;
   295		struct nx842_constraints c;
   296		unsigned int groups, hdrsize, h;
   297		int ret, n;
   298		bool add_header;
   299		u16 ignore = 0;
   300	
   301		if (!tfm || !src || !slen || !dst || !dlen)
                     ^^^
Checked for NULL.

   302			return -EINVAL;
   303	


The decompress function has the same warning:

	drivers/crypto/nx/nx-842-crypto.c:486 nx842_crypto_decompress()
	warn: variable dereferenced before check 'tfm' (see line 478)

regards,
dan carpenter
