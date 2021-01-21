Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4359C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 06:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C2E2389B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 06:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAUF7y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 00:59:54 -0500
Received: from sender4-op-o18.zoho.com ([136.143.188.18]:17835 "EHLO
        sender4-op-o18.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAUF7f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 00:59:35 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1611208726; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=YQktLSUJsK8AtlbvLC4h53fySjqpRQmWZaKH3nw8vkPm9Qai9rjBopPFo6n9Hepecd935PW0Xzpamw5rGK1ZDDP0Y0LptJ3yDauiB+C406SzULjHERiO78PWSl+k5VlRv1SmT9Fr5d74VceOiCkKP/XdK/DVQr/qS/GnCwnFhFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1611208726; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uaa9q1Dcw6tkG8ngmP0tWjSpTRhMEXi75Rce+2y0sz4=; 
        b=mOk6sGdyUuDRKWlACkumlovl6cpvpVwDeCRBh3OOTLf56t9dEkSYJE80Q0xxJ7XKnV9HqJ7hFR2MNa8S9rvGaoD2jpwSRKsFqTiXYMAi0RSQfQtoBodbeuepe1j85AmpfJ9Vq76zv5F+5mxd7V91a8/XCEdCSdfSKkyzeOyY0Ow=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=in04.sg;
        spf=pass  smtp.mailfrom=angelsl@in04.sg;
        dmarc=pass header.from=<angelsl@in04.sg> header.from=<angelsl@in04.sg>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zoho; d=in04.sg; 
  h=subject:to:references:from:message-id:date:user-agent:mime-version:in-reply-to:content-type; 
  b=gAz3dXrHYhX3c18xscvapjwToU3E3GV1+YI7LKwSJhx0f2P0kcU2gt51WSaWFlqOylqV4Mr2pUJq
    wUIje/a+0nX4N7wAF+TtxtvSUlsBsl2uni0MGbJFYIm2omeeI6BurLA4RYM06zPXjXt44bLbCIie
    EbkudknKqwaJD8OV8Vs=  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1611208726;
        s=zoho; d=in04.sg; i=angelsl@in04.sg;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=uaa9q1Dcw6tkG8ngmP0tWjSpTRhMEXi75Rce+2y0sz4=;
        b=fdvA+nWoP+dRCAsSImW84eabPUDd9eYQ5C5v4IE6+xoBkx+Hz4xYskfpkv6BF4Re
        43z7Zlf2rU+UQ7vAtE06xDl8jlpcop8G6xyXjIinoGEhUF0k5H7nuiDXs0se59BYQe+
        A+Pyjr1osr/Pvvs0Zhm+8z1fTpAlV/WfWLzwjtLg=
Received: from [10.0.117.1] (116.89.67.3 [116.89.67.3]) by mx.zohomail.com
        with SMTPS id 161120872504237.28095668137382; Wed, 20 Jan 2021 21:58:45 -0800 (PST)
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
To:     linux-crypto@vger.kernel.org
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk> <87sg6yqich.fsf@toke.dk>
 <91cbcae9-2bc8-16ed-678f-46903e15aaa1@ua.pt>
From:   Tee Hao Wei <angelsl@in04.sg>
Message-ID: <14421eec-28e0-9353-7308-32787fee4def@in04.sg>
Date:   Thu, 21 Jan 2021 13:58:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <91cbcae9-2bc8-16ed-678f-46903e15aaa1@ua.pt>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/1/21 5:09 am, Jo=C3=A3o Fonseca wrote:
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>=20
>> David Howells <dhowells@redhat.com> writes:
>>
>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>>>
>>>> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>
>>>> and also, if you like:
>>>>
>>>> Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>> Thanks!
>> Any chance of that patch getting into -stable anytime soon? Would be
>> nice to have working WiFi without having to compile my own kernels ;)
>>
>> -Toke
>>
>>
>>
> I have also just tested the patch and it seems to be working with the
> PEAP method. I would also like to have this patch in the stable branch
> as I normally don't have to compile my own kernels.
>=20
> Also, if you want to add another tester:
>=20
> Tested-by: Jo=C3=A3o Fonseca <jpedrofonseca@ua.pt>
>=20
> Thanks for the patch everyone.
>=20
> -Jo=C3=A3o
>=20
>=20

The patch finally made it to Torvalds's tree a few hours ago, so it=20
should hopefully land in the next stable patch.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D7178a107f5ea7bdb1cc23073234f0ded0ef90ec7

--=20
Hao Wei

