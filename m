Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A2FC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 13:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1477B206B5
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 13:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="QAgrJVY2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHRN4S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:56:18 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:37596 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgHRN4Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 09:56:16 -0400
Received: from [192.168.254.6] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 97D5F13C2B0;
        Tue, 18 Aug 2020 06:56:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 97D5F13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1597758973;
        bh=h6tkVxAlbm3mBbnxPCxhv+aa86rZjfk2i0BeaR+ghUA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QAgrJVY247YXueqOYPzwpvvWMYlniv03RlFoRHUJ+vTPpd7YjbOhVyKLeSyZJY2r+
         mmI+aAHCRJ+Fg4xZOYqZ6eE2zGom5WKcSJqjJjEgZIyOl1GFaMQfje82C5+Ezq0Fnt
         EOxZsZ3kAbvOYUwULiA/gkcgtaSLfAGJ9SuMkffQ=
Subject: Re: [PATCH 0/5] crypto: Implement cmac based on cbc skcipher
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20200802090616.1328-1-ardb@kernel.org>
 <20200818082410.GA24497@gondor.apana.org.au>
 <CAMj1kXFOZJFUR0N+6i2O4XGZ462Mcs8pq7y_MYScfLf-Tfy3QQ@mail.gmail.com>
 <20200818135128.GA25652@gondor.apana.org.au>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <2aad9569-877e-4398-88ef-e40d9bbf7656@candelatech.com>
Date:   Tue, 18 Aug 2020 06:56:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818135128.GA25652@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/18/20 6:51 AM, Herbert Xu wrote:
> On Tue, Aug 18, 2020 at 10:31:39AM +0200, Ard Biesheuvel wrote:
>>
>> What do you mean? You cannot implement cbcmac using a cbc skcipher
>> unless you provide a scratch buffer of arbitrary size as the
>> destination, in order to capture the skcipher output IV as the MAC.
> 
> Please have a look at patch 6.  The trick is to use an SG list
> chained to itself.

Herbert, thanks for working on this.  If I apply the patches you posted,
that is expected to provide wifi aes decryption speedup similar to what
the original patch I sent does?  Or, are additional patches needed?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
