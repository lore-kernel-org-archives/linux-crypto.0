Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EA2C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Feb 2022 08:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiBNIxt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Feb 2022 03:53:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiBNIxt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Feb 2022 03:53:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F95F8F5;
        Mon, 14 Feb 2022 00:53:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B603C210ED;
        Mon, 14 Feb 2022 08:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644828820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQQB3ufKaFwaBgP/hi+JA5BY0In9wvHVjl8VlzdEY38=;
        b=JhgdIqQBw9Q2Z912mjMbobP+sbGK8tPwuZoo4aaoMs80Qwto31JjrdSnGLOPkjFy9UNioM
        u4KEtKBCzsGhntJQQZYZbQ3gTi1SRv0MkXVsxeSZpJwzYBmGV7Ujbd4lxjkCFLNiQ3toJC
        C6HxuEMhHH2xlYRz6eQwQBR0RSCz7ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644828820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQQB3ufKaFwaBgP/hi+JA5BY0In9wvHVjl8VlzdEY38=;
        b=UEwmDpq2gDdxm0uyxDogkZJ7YU//fe/PEAj8AseTrm90ao8k86MR/SIHCukXj+bynRdyue
        lJNhtfOroS2bxfCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 51105139F7;
        Mon, 14 Feb 2022 08:53:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hYUMEpQYCmLFEQAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 14 Feb 2022 08:53:40 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Nicolai Stange <nstange@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>,
        Hannes Reinecke <hare@suse.de>, Torsten Duwe <duwe@suse.de>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH v3 11/15] crypto: dh - allow for passing NULL to the ffdheXYZ(dh)s' ->set_secret()
References: <20220202104012.4193-1-nstange@suse.de>
        <20220202104012.4193-12-nstange@suse.de>
        <YgYnu8ZzhSnr+OgZ@gondor.apana.org.au>
Date:   Mon, 14 Feb 2022 09:53:40 +0100
In-Reply-To: <YgYnu8ZzhSnr+OgZ@gondor.apana.org.au> (Herbert Xu's message of
        "Fri, 11 Feb 2022 20:09:15 +1100")
Message-ID: <87bkz9q163.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Feb 02, 2022 at 11:40:08AM +0100, Nicolai Stange wrote:
>> Ephemeral key generation can be requested from any of the ffdheXYZ(dh)
>> variants' common ->set_secret() by passing it an (encoded) struct dh
>> with the key parameter being unset, i.e. with ->key_size =3D=3D 0. As the
>> whole purpose of the ffdheXYZ(dh) templates is to fill in the group
>> parameters as appropriate, they expect ->p and ->g to be unset in any
>> input struct dh as well. This means that a user would have to encode an
>> all-zeroes struct dh instance via crypto_dh_encode_key() when requesting
>> ephemeral key generation from a ffdheXYZ(dh) instance, which is kind of
>> pointless.
>>=20
>> Make dh_safe_prime_set_secret() to decode a struct dh from the supplied
>> buffer only if the latter is non-NULL and initialize it with all zeroes
>> otherwise.
>>=20
>> That is, it is now possible to call
>>=20
>>   crypto_kpp_set_secret(tfm, NULL, 0);
>>=20
>> on any ffdheXYZ(dh) tfm for requesting ephemeral key generation.
>
> Why do we need to support the non-NULL case? IOW what in the kernel
> will be using these new templates with a non-NULL parameter?

The only "real" user, NVME in-band auth, will indeed only use ephemeral
keys AFAICT, but the known-answer selftests install a static key each.
So those will have to invoke ->set_secret() with a non-NULL parameter.

Thanks,

Nicolai

--=20
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, G=
ermany
(HRB 36809, AG N=C3=BCrnberg), GF: Ivo Totev
