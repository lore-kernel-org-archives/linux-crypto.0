From: Carlo Caione <carlo@caione.org>
Subject: Re: [PATCH RESEND] X.509: Recognize the legacy OID 1.3.14.3.2.29 (sha1WithRSASignature)
Date: Thu, 7 Sep 2017 10:44:19 +0200
Message-ID: <CAOQ7t2Zd+JaewCDkUEmh6bVJV85pN6XYmjVWpa515Cx2QrEtgQ@mail.gmail.com>
References: <20170807080151.5313-1-carlo@caione.org> <CAOQ7t2Y+QX_GWj=Sii6VKbY4N9UfZc5cFriC3RfFWVxSobd-Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Carlo Caione <carlo@endlessm.com>
To: Carlo Caione <carlo@caione.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:38175 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbdIGIoU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 04:44:20 -0400
In-Reply-To: <CAOQ7t2Y+QX_GWj=Sii6VKbY4N9UfZc5cFriC3RfFWVxSobd-Xw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 21, 2017 at 9:27 AM, Carlo Caione <carlo@caione.org> wrote:
> On Mon, Aug 7, 2017 at 10:01 AM, Carlo Caione <carlo@caione.org> wrote:
>> From: Carlo Caione <carlo@endlessm.com>
>>
>> We have found some ACER laptops shipping with certificates signed using
>> the 1.3.14.3.2.29 OID. This is causing the message
> /cut
>
> Ping on this (literally) two lines patch.

any feedback on this small patch?

-- 
Carlo Caione
