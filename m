Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940A1C3A5A6
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 15:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6571523428
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567094315;
	bh=nj0U9SGIgoP+SiWF11LyGTpSq7TNiqMEvEF4ZodQNHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1Fwo3sVyxFMf7AU4ivYplseciB/dkovVaKDwNdRx16zNuS8Ubxv5biNbttE5E1I9p
	 jy2necNFZfWjRkSAVgjQ8KgdtcUM3qPIyLJOCE7GvckFZF4XmTfe/bIFGAcOtNEgUT
	 JQmc5IEQBSm2WYEcEoqJ+RqaiguTH+VudrWKO7kc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfH2P6e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2P6e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 11:58:34 -0400
Received: from zzz.localdomain (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF4420578;
        Thu, 29 Aug 2019 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567094312;
        bh=nj0U9SGIgoP+SiWF11LyGTpSq7TNiqMEvEF4ZodQNHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5EYYBsl/vvk5LMiSF3JHds526ds5lv5ok6JDArgYKX0k00l3MKDlQy7EIXCXN/tj
         hgJAD1+gkwSLKCwAtVrDPJfvxjvQ3q6pATcrj/vO/cAXrgppo1ny6SsFi5eYC5tKt5
         cdz4abWNrDASPx3o2+o0nyNZiUUJwq/cDV0yOtN8=
Date:   Thu, 29 Aug 2019 10:58:19 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/15] crypto: testmgr - convert hash testing to use
 testvec_configs
Message-ID: <20190829155819.GA14558@zzz.localdomain>
Mail-Followup-To: Christophe Leroy <christophe.leroy@c-s.fr>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
References: <20190201075150.18644-1-ebiggers@kernel.org>
 <20190201075150.18644-14-ebiggers@kernel.org>
 <e1ce6e9f-dc20-79bc-cd53-faff92481f7a@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1ce6e9f-dc20-79bc-cd53-faff92481f7a@c-s.fr>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 29, 2019 at 05:32:46PM +0200, Christophe Leroy wrote:
> Hi Eric,
> 
> 
> Le 01/02/2019 à 08:51, Eric Biggers a écrit :
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Convert alg_test_hash() to use the new test framework, adding a list of
> > testvec_configs to test by default.  When the extra self-tests are
> > enabled, randomly generated testvec_configs are tested as well.
> > 
> > This improves hash test coverage mainly because now all algorithms have
> > a variety of data layouts tested, whereas before each algorithm was
> > responsible for declaring its own chunked test cases which were often
> > missing or provided poor test coverage.  The new code also tests both
> > the MAY_SLEEP and !MAY_SLEEP cases and buffers that cross pages.
> > 
> > This already found bugs in the hash walk code and in the arm32 and arm64
> > implementations of crct10dif.
> > 
> > I removed the hash chunked test vectors that were the same as
> > non-chunked ones, but left the ones that were unique.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >   crypto/testmgr.c | 795 ++++++++++++++++++++---------------------------
> >   crypto/testmgr.h | 107 +------
> >   2 files changed, 352 insertions(+), 550 deletions(-)
> > 
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 7638090ff1b0a..96aa268ff4184 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> 
> [...]
> 
> 
> > -static int __test_hash(struct crypto_ahash *tfm,
> > -		       const struct hash_testvec *template, unsigned int tcount,
> > -		       enum hash_test test_type, const int align_offset)
> > +static int test_hash_vec_cfg(const char *driver,
> > +			     const struct hash_testvec *vec,
> > +			     unsigned int vec_num,
> > +			     const struct testvec_config *cfg,
> > +			     struct ahash_request *req,
> > +			     struct test_sglist *tsgl,
> > +			     u8 *hashstate)
> >   {
> > -	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
> > -	size_t digest_size = crypto_ahash_digestsize(tfm);
> > -	unsigned int i, j, k, temp;
> > -	struct scatterlist sg[8];
> > -	char *result;
> > -	char *key;
> > -	struct ahash_request *req;
> > -	struct crypto_wait wait;
> > -	void *hash_buff;
> > -	char *xbuf[XBUFSIZE];
> > -	int ret = -ENOMEM;
> > -
> > -	result = kmalloc(digest_size, GFP_KERNEL);
> > -	if (!result)
> > -		return ret;
> > -	key = kmalloc(MAX_KEYLEN, GFP_KERNEL);
> > -	if (!key)
> > -		goto out_nobuf;
> > -	if (testmgr_alloc_buf(xbuf))
> > -		goto out_nobuf;
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
> > +	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
> > +	const unsigned int statesize = crypto_ahash_statesize(tfm);
> > +	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
> > +	const struct test_sg_division *divs[XBUFSIZE];
> > +	DECLARE_CRYPTO_WAIT(wait);
> > +	struct kvec _input;
> > +	struct iov_iter input;
> > +	unsigned int i;
> > +	struct scatterlist *pending_sgl;
> > +	unsigned int pending_len;
> > +	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
> 
> Before this patch, result was allocated with kmalloc().
> Now, result is in the stack. Is there a reason for this change ?
> 
> Due to this change, the talitos driver fails when using CONFIG_VMAP_STACK,
> because result is not dma-able anymore.
> 

Yes, moving 'result' to the stack simplified the code slightly and also helps
detect buggy drivers that assume that 'result' is DMA-able.  Note that some
"real" API users also put 'result' on the stack, as the API allows it.
This is not new; the only new thing is that the tests now test it.

> 
> How should this be fixed ?
> 

Take a look at how other drivers have fixed this issue in the past, e.g.
commit c19650d6ea9 ("crypto: caam - fix DMA mapping of stack memory").
Seems that you need to DMA into a temporary buffer.

- Eric
