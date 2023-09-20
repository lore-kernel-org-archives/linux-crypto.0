Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB29C04AB8
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Sep 2023 17:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbjITRMs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Sep 2023 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbjITRMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2023 13:12:38 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810C2CE0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 10:12:15 -0700 (PDT)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 47E673F63E
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1695229932;
        bh=aMSN2b6FPtP71Yuy3aOolSBsWw71Z7rbqelM6LCeABc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PZFOUyvNwKjZhnPdq4P8h+4KERFN5u61gDjdQFNQ4NMOHtfBVk8mUta9GrhlqkP5G
         VoaAe5H8p+nNQOht+I5MRvogffessdq8vO8aXiTyBvi+5I3odyviUOeZE30V/mawRc
         j90kvAPgdUaOBq+NQO0TIgRnBsbnTv5fwzYEzM0YRidPkhzGC/h0XaPGW1Hniut+Zt
         giYusWHv0mKjFH5nj+Xmg3BinQzhvR0iT8VTg/yy3F8xpwf+84TNery7EwIGsP+5hG
         9G9A07tNoyXjM+UNbb7CXBCy5Bf2jrxPsJ1UgcFgzfFaeI6Ag76pv2n4dyn+CRbnvR
         gsVAjAIhvUBVg==
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-402cba95486so423835e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 Sep 2023 10:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695229932; x=1695834732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMSN2b6FPtP71Yuy3aOolSBsWw71Z7rbqelM6LCeABc=;
        b=ntgYI0DtoFJAg/JxGC1CABjHkZglkZsGd8DuCKo6FrBndHD8V0UkYnUvJdp8Ew+89h
         2zuNt2EtMqRmVVpuO6RDwz6VjVnSb8+AYWjne7yMvXuj1LtYWxY7RUeaLaYyqfzepPSs
         uBKGxXlNxrhDbzfFk0amZT9/h03szEl4+M60hDSX3ZG6YRKcbVqz4ogaXf2HyNv7cY7m
         qlY9t0TZCyZjGbNh/HR5tQxzVBvqFB1qSWnaG4guNzkrNksnR5Zwo36CGZ7nYJc9Qnzg
         tDbnvqTa02mNGnCF0u2pcNQNF9/OlQLBXvEkAQjcfXneVITYgMq1uQwh3G10ickKHRNq
         yccQ==
X-Gm-Message-State: AOJu0Yx7eQjaUnD3mXhr4FftIeonlBztNdhL7uTnxiOyvrf95A9U2AwZ
        zRX1yxKnhLm7O2XUM5Mx5GxoQojpEXfUaavqUA37Fgpeoq0XJLKALWBtotGRfhsGJ2pKHI3gkMX
        iO+kDgsFOKWaHdcfc1LzVPjXBTRJKZD5DSuYqSXeCXg==
X-Received: by 2002:a1c:f204:0:b0:401:c944:a4d6 with SMTP id s4-20020a1cf204000000b00401c944a4d6mr2601712wmc.28.1695229931798;
        Wed, 20 Sep 2023 10:12:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtIk2rtiYUS9ShClNXvyZriX2xgTDxVioqlVjWWDSc5z5AFzcfx8XmtDp+shKbfv5XjqgSpg==
X-Received: by 2002:a1c:f204:0:b0:401:c944:a4d6 with SMTP id s4-20020a1cf204000000b00401c944a4d6mr2601692wmc.28.1695229931401;
        Wed, 20 Sep 2023 10:12:11 -0700 (PDT)
Received: from localhost ([2a01:4b00:85fd:d700:6aa5:dc9f:c265:61f4])
        by smtp.gmail.com with ESMTPSA id c26-20020a05600c0ada00b00400268671c6sm2484584wmr.13.2023.09.20.10.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 10:12:11 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, dhowells@redhat.com, jarkko@kernel.org,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
        varad.gautam@suse.com, vt@altlinux.org
Subject: Re: [PATCH v3 13/18] crypto: rsa-psspad: Get signature parameters from a given signature
Date:   Wed, 20 Sep 2023 18:12:06 +0100
Message-Id: <20230920171206.504360-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20210514104535.q4zjtshxroruvoz3@gondor.apana.org.au>
References: <20210514104535.q4zjtshxroruvoz3@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Tue, Apr 20, 2021 at 01:41:18PM +0200, Varad Gautam wrote:
>>
>> +static int psspad_set_sig_params(struct crypto_akcipher *tfm,
>> +				 const void *sig,
>> +				 unsigned int siglen)
>> +{
>> +	struct akcipher_instance *inst = akcipher_alg_instance(tfm);
>> +	struct rsapad_inst_ctx *ictx = akcipher_instance_ctx(inst);
>> +	const struct public_key_signature *s = sig;
>> +
>> +	if (!sig)
>> +		return -EINVAL;
>> +
>> +	ictx->salt_len = s->salt_length;
>> +	ictx->mgf_hash_algo = s->mgf_hash_algo;
>
> Is there any reason why this couldn't be embedded into the key
> instead?
>

Whilst is is correct that the same key can be used to verify either
types of signatures, it is best practice to use separate and new keys
in such situations. This prevents compromising key due to any
weaknesses in the one or the other signature types.

Thus imho it does make sense to embed sal_len & hash_algo into the key
instead, and thus only allow PSS signature verification with such a
key. This is common for x509 certs too as used in TLS. (at least this
is my understanding of all of this).

But this is a minor point which can fix now or later.

BTW, this patch series overall look very good to me and I want to use
PSS signatures in my kernel builds. What is the status of merging this
patch series?

Regards,

Dimitri.
