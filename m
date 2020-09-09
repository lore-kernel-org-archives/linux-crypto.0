Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A994C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 17:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B222078B
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 17:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oPmvedGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIIRkp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIRkn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 13:40:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B11C061573;
        Wed,  9 Sep 2020 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=F/gEpRM7m8NWklb0InYkX+du0rIZvQsNzkrx+mVaWlE=; b=oPmvedGzIxQBZ3rnKe8D1Y6vTO
        1tLYLnag/oyEbVQcUvwtz36qZGRLITwasdjpLx/XfllI8gE/k60CKZSDEqmC5WURfx5XlHmY3Uwdu
        gCXtFIE9XKQqo8+5eaZdBedAkghqtIMHnoev9G46IrQIj013y5d18Ijut+SgzZGpb16dA2ENuOkjJ
        SrIuFYb+T/020R2q3hpZhidadMgTcjwDSC6a8kx5Y3ayMZ1ip0oWyuFNYjicVO1Fnk4rSKdHcvMec
        +qPOPETy/dEgIqt2emXjNRZJp3+sIGgoymlBcO9qwWOswesNebV+zD4VeNMd4/YtWwQRQpNKKVwIh
        gXfNIJpg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG45D-00025N-Jz; Wed, 09 Sep 2020 17:40:35 +0000
Subject: Re: [PATCH v2] certs: Add EFI_CERT_X509_GUID support for dbx entries
To:     Eric Snowberg <eric.snowberg@oracle.com>, dhowells@redhat.com,
        dwmw2@infradead.org, jarkko.sakkinen@linux.intel.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        jmorris@namei.org, serge@hallyn.com, nayna@linux.ibm.com,
        zohar@linux.ibm.com, erichte@linux.ibm.com, mpe@ellerman.id.au,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
References: <20200909172736.73003-1-eric.snowberg@oracle.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5074bc5c-8dd4-16d7-2760-3e657b90bfa2@infradead.org>
Date:   Wed, 9 Sep 2020 10:40:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909172736.73003-1-eric.snowberg@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/9/20 10:27 AM, Eric Snowberg wrote:
> diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
> index 38ec7f5f9041..d8f2e0fdfbf4 100644
> --- a/include/crypto/pkcs7.h
> +++ b/include/crypto/pkcs7.h
> @@ -26,11 +26,19 @@ extern int pkcs7_get_content_data(const struct pkcs7_message *pkcs7,
>  				  const void **_data, size_t *_datalen,
>  				  size_t *_headerlen);
>  
> +#ifdef CONFIG_PKCS7_MESSAGE_PARSER
>  /*
>   * pkcs7_trust.c
>   */
>  extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
>  				struct key *trust_keyring);
> +#else
> +static inline int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
> +				       struct key *trust_keyring)
> +{
> +	return -ENOKEY;
> +}
> +#endif

Just to be clear, you want to do the #else block when
CONFIG_PKCS7_MESSAGE_PARSER=m.  Is that correct?

If so, it might be clearer to use

#if IS_BUILTIN(CONFIG_PKCS7_MESSAGE_PARSER)


-- 
~Randy

