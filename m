Return-Path: <SRS0=SXL7=D3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CA7C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023322224B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Oct 2020 14:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oCZp0Ll9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394393AbgJTO4k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393788AbgJTO4k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Oct 2020 10:56:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063BBC061755;
        Tue, 20 Oct 2020 07:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=CkRjSwN2ekutE0mI535+FdxXd84S60cjRq0lmzMBzkA=; b=oCZp0Ll9yGHGj8/+4mJJQ0pUti
        HkWXAD7oAcQLn2bcvYoQI31GVMyUtd/wRNvQhkiUeeZK5/2lDpi/lKGdSbcHu+tJupi8n5U+0nFl6
        cXWMwVm2icM5gDI+6+QUICvw+kpSSCRt1MZ89oSl20Fc0AzBHAk7Oz2DK62DMk+XfFb5cWRPRR9H6
        0SrgN12WERVk2IXU+3UdG6Bb+rZ4gPwjFAXMo1Ud4AQG20nP4RdDM84LGKQKoWNsIdYlpSZe4JpJd
        s7ZwD+hFoE5MpVck+w2+oUiSFKLXunwAT/Kn/cN6S32g8xUipEx9t1TWMnaesXD26yiCg7KyH2Ell
        aKO0aW2g==;
Received: from [2601:1c0:6280:3f0::507c]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kUt3x-0001SQ-34; Tue, 20 Oct 2020 14:56:34 +0000
Subject: Re: [RFC PATCH 2/2] PKCS#7: Check codeSigning EKU for kernel module
 and kexec pe verification
To:     list.lkml.keyrings@me.benboeckel.net,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
References: <20201020065001.13836-1-jlee@suse.com>
 <20201020065001.13836-3-jlee@suse.com>
 <20201020134208.GA297878@erythro.dev.benboeckel.internal>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <885f1b81-6141-a3be-1dc0-92c1fc825e3c@infradead.org>
Date:   Tue, 20 Oct 2020 07:56:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201020134208.GA297878@erythro.dev.benboeckel.internal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/20/20 6:42 AM, Ben Boeckel wrote:
> On Tue, Oct 20, 2020 at 14:50:01 +0800, Lee, Chun-Yi wrote:
>> +config CHECK_CODESIGN_EKU
>> +	bool "Check codeSigning extended key usage"
>> +	depends on PKCS7_MESSAGE_PARSER=y
>> +	depends on SYSTEM_DATA_VERIFICATION
>> +	help
>> +	  This option provides support for checking the codeSigning extended
>> +	  key usage extension when verifying the signature in PKCS#7. It

	  extended ... extension.
Can we drop one of those or reword it?

>> +	  affects kernel module verification and kexec PE binary verification
>> +	  now.
> 
> Is the "now" necessary? Isn't it implied by the option's existence?


-- 
~Randy

