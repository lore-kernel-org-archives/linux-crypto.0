Return-Path: <SRS0=Hj06=BI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EBFC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 16:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FD120FC3
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jul 2020 16:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D87XQE4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgG2QFc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jul 2020 12:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgG2QFc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jul 2020 12:05:32 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B802C061794;
        Wed, 29 Jul 2020 09:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=VgRSKXlVkUA+wItQ1Yesqt0DqERY9tDDk1U1v1+rmjc=; b=D87XQE4IvPC76f/jdR58xUN6a1
        qNh7BPED4JT4BPDwbs70qaTy6+FVuym0TEs3Vw4wuM3DjblfQcPyM48whmcanyIkRoI5Vex7omssr
        mS51Y030Hs5AGlMkxgnoNwQG/D+3E80YmbqDane5JAry1c3ygOOMVaDA5C0yNhd8+Cy/5glMNZkgT
        4VBYxn1Ux/qUr8PlV6aM/LTmbWQUlIfB70YFEapz4MpOzfuRVeJB2tIpUz0EQ5cOE/1JF6OD6GVlo
        hZTLSP3uRdXQGxF7+qcOYpLebCttTL6AWb46IblzSgsc/ZbzRdsLr6uI1HTOgURX0khGxBdDjtnIz
        HI9DnOPA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0oa9-0006wD-Hg; Wed, 29 Jul 2020 16:05:29 +0000
Subject: Re: linux-next: Tree for Jul 29 (drivers/crypto/sa2ul.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Keerthy <j-keerthy@ti.com>
References: <20200729222201.0d1ec18a@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <14aed575-cd6a-ff64-d040-323c2847df93@infradead.org>
Date:   Wed, 29 Jul 2020 09:05:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729222201.0d1ec18a@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/29/20 5:22 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200728:
> 

on i386:

ld: drivers/crypto/sa2ul.o: in function `sa_sha_digest':
sa2ul.c:(.text+0x1faf): undefined reference to `sha512_zero_message_hash'


sa2ul.c uses sha512_zero_message_hash, sha1_zero_message_hash,
and sha256_zero_message_hash, but it does not 'select' any of the
Kconfig symbols that cause those hashes to be present.

Should it select the needed Kconfig symbols or should it use
#ifdef blocks as needed?

like so:


static int zero_message_process(struct ahash_request *req)
{
	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
	int sa_digest_size = crypto_ahash_digestsize(tfm);

	switch (sa_digest_size) {
#ifdef CONFIG_CRYPTO_SHA1
	case SHA1_DIGEST_SIZE:
		memcpy(req->result, sha1_zero_message_hash, sa_digest_size);
		break;
#endif
#ifdef CONFIG_CRYPTO_SHA256
	case SHA256_DIGEST_SIZE:
		memcpy(req->result, sha256_zero_message_hash, sa_digest_size);
		break;
#endif
#ifdef CONFIG_CRYPTO_SHA512
	case SHA512_DIGEST_SIZE:
		memcpy(req->result, sha512_zero_message_hash, sa_digest_size);
		break;
#endif
	default:
		return -EINVAL;
	}

	return 0;
}



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
