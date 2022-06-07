Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2806C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jun 2022 09:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiFGJF7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbiFGJF6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jun 2022 05:05:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77DE4D2471
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2022 02:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654592756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HhinCZb2A9zT1SaIBzoENIRctzxd17wZ4GhZVdK/SiM=;
        b=JMi82Rs6HWHoGnmrMLQBV22gDWtP5oO9TUFAzPPtM9IzYIEyLeQJVPGp+9Dybd4uyF28QG
        1qVpgqDoYcjmLehqUWPWrxqwzyJFBHzj+aiAXs6J1lV0WeOMuU8Q8LLBeYz0dYW1UiJzVZ
        5WWakmswsL+ZT6lNLoZD8f0gImcpx6U=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-VZ7hXx8fPfCpgjB1m_exmQ-1; Tue, 07 Jun 2022 05:05:55 -0400
X-MC-Unique: VZ7hXx8fPfCpgjB1m_exmQ-1
Received: by mail-lj1-f200.google.com with SMTP id s15-20020a2e9c0f000000b002554eee26ebso2847543lji.21
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jun 2022 02:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HhinCZb2A9zT1SaIBzoENIRctzxd17wZ4GhZVdK/SiM=;
        b=C9B15If2pFW8kxagDzftFlMtSacqyMgm35WSa6RrUCiXUX2yOc0A0Vq4/YYfPTHozG
         DosxKvTa++IDFuhriewkzQAzrB4RmATj7TK7YyqmG6VZtmpab5TiJuBKwL/FlvmAVkxs
         Ag8dBF3P03GGMFn+B/arMKQMa2uk3tuAJjaOf9YSiR1l1wOt2CzBxFB8ng2NxDtSM4F2
         HnJRW82XNpgwTI97GykXUa3BAlPZfTpYst9R/hnWaOoqhJBvRbW9ozXCIpsjFpyuS5Ow
         198BwfPbGKOofmbmw5Dkp2rOuxJpwsfbsUaXWXVdLmrNZe8Rpfx9KKw7RSRTHL8JRVxX
         xkEQ==
X-Gm-Message-State: AOAM532FHOT+1TAAxRO/SlZTVtkZMzgVnaqiH+fSYPGLFR8zK3U7Qj2D
        ytL50tjrnt1jRnDuvuVhLOFnHSGuutWRCmD7c/vu2Hu7FiDifLEB7lbc7PshtMNwuljFo1Ctf3/
        ynLWyWPem5Ib7/J/5gPiBw5iUEQJvbim6ArKyQor7
X-Received: by 2002:ac2:4e0f:0:b0:479:54a6:f9bb with SMTP id e15-20020ac24e0f000000b0047954a6f9bbmr4062067lfr.257.1654592753310;
        Tue, 07 Jun 2022 02:05:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIDIoF2LjR2OH4SEODLzhZJg0EllYDRK8WAKxmcexYZWRF7HIyxPgpDkGpn53Kll+hiDhH2iHOfgcC1b+DWMs=
X-Received: by 2002:ac2:4e0f:0:b0:479:54a6:f9bb with SMTP id
 e15-20020ac24e0f000000b0047954a6f9bbmr4062047lfr.257.1654592753037; Tue, 07
 Jun 2022 02:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fc128605e08585c6@google.com> <00000000000068486805e0d68f94@google.com>
In-Reply-To: <00000000000068486805e0d68f94@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 7 Jun 2022 17:05:41 +0800
Message-ID: <CACGkMEvCmtmfBSDeq1psgW4+MTymfs_T-EFQx=2UdXfy1vWDiw@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in add_early_randomness (2)
To:     syzbot <syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux@dominikbrodowski.net, mpm@selenic.com, mst <mst@redhat.com>,
        syzkaller-bugs@googlegroups.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, yuehaibing@huawei.com
Content-Type: multipart/mixed; boundary="0000000000004b57ae05e0d7e507"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--0000000000004b57ae05e0d7e507
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 7, 2022 at 3:30 PM syzbot
<syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit 8b4ec69d7e098a7ddf832e1e7840de53ed474c77
> Author: Jason Wang <jasowang@redhat.com>
> Date:   Fri May 27 06:01:19 2022 +0000
>
>     virtio: harden vring IRQ
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1175c3c7f00000
> start commit:   f2906aa86338 Linux 5.19-rc1
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1375c3c7f00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1575c3c7f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd131cc02ee620e
> dashboard link: https://syzkaller.appspot.com/bug?extid=5b59d6d459306a556f54
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104f4d4ff00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d6782df00000
>
> Reported-by: syzbot+5b59d6d459306a556f54@syzkaller.appspotmail.com
> Fixes: 8b4ec69d7e09 ("virtio: harden vring IRQ")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>

I wonder if it's related to shared IRQ.

Want to know if the attached patch works.

Thanks

--0000000000004b57ae05e0d7e507
Content-Type: application/octet-stream; 
	name="0001-virtio_ring-use-IRQ_HANDLED.patch"
Content-Disposition: attachment; 
	filename="0001-virtio_ring-use-IRQ_HANDLED.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l43xsnpi0>
X-Attachment-Id: f_l43xsnpi0

RnJvbSAyY2JlOWYwODViMTZiOGExOTE4ODFiZTg4MDgxOGQwNzA1NjQxNzhkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPgpEYXRl
OiBUdWUsIDcgSnVuIDIwMjIgMTY6NTY6MjcgKzA4MDAKU3ViamVjdDogW1BBVENIXSB2aXJ0aW9f
cmluZzogdXNlIElSUV9IQU5ETEVELgpDb250ZW50LXR5cGU6IHRleHQvcGxhaW4KClNpZ25lZC1v
ZmYtYnk6IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+Ci0tLQogZHJpdmVycy92aXJ0
aW8vdmlydGlvX3JpbmcuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMg
Yi9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fcmluZy5jCmluZGV4IDEzYTczNDhjZWRmZi4uMWFmNTVl
NTc2NTA1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3ZpcnRpby92aXJ0aW9fcmluZy5jCisrKyBiL2Ry
aXZlcnMvdmlydGlvL3ZpcnRpb19yaW5nLmMKQEAgLTIxMzcsNyArMjEzNyw3IEBAIGlycXJldHVy
bl90IHZyaW5nX2ludGVycnVwdChpbnQgaXJxLCB2b2lkICpfdnEpCiAJaWYgKHVubGlrZWx5KHZx
LT5icm9rZW4pKSB7CiAJCWRldl93YXJuX29uY2UoJnZxLT52cS52ZGV2LT5kZXYsCiAJCQkgICAg
ICAidmlydGlvIHZyaW5nIElSUSByYWlzZWQgYmVmb3JlIERSSVZFUl9PSyIpOwotCQlyZXR1cm4g
SVJRX05PTkU7CisJCXJldHVybiBJUlFfSEFORExFRDsKIAl9CiAKIAkvKiBKdXN0IGEgaGludCBm
b3IgcGVyZm9ybWFuY2U6IHNvIGl0J3Mgb2sgdGhhdCB0aGlzIGNhbiBiZSByYWN5ISAqLwotLSAK
Mi4yNS4xCgo=
--0000000000004b57ae05e0d7e507--

