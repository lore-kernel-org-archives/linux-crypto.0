Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BBEC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 18:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F9F2064A
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 18:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXCmGp9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF0STx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 14:19:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35124 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF0STx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 14:19:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so1392207pgl.2;
        Thu, 27 Jun 2019 11:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YxWB64ryDTAukr5Ntc6C0h8QlbYoWm2vudWLQPZyntg=;
        b=EXCmGp9PEcUVA3irnDJK4OVTXv2Sl7cZRSj65JU9vsOjqWmuqs6yDubTP2RMCaRb3O
         dZWfwZjkGqxIMxgfzcl035UUwoyGCHsKBd1VHFoCnMpOToT2/gzA4FzeYgdIPIJY2tZb
         1Oh6tqb2JlvLHyHpaRoMRvOifmqtBhB5Z2GL77f59yBXVsG45GhQ36yi9Uw/vgEaGtiu
         GyNDMsbV7CjlTFkXJT+mTAdS+0HLn3bEGURNT6Ss/wiAGmZlQvGPVPscLLdwiWiKFH3M
         cN/PkxDdNmBto3PnfR96yTh54RoE7sCklobvdymQkw7jxrmW4XhtG5hVLPmspclg0z97
         8L5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YxWB64ryDTAukr5Ntc6C0h8QlbYoWm2vudWLQPZyntg=;
        b=cwuTXEIDw3bpgFfD4t9aNwlUO8m5Kf/NgWrr+U8PpLfyWSNdcUVtPnT8oLm5KPGnCR
         jpb0RqKt8H3gxfD5EweswuOViWv5PhSCt2PoeUnF0aGFfU8pR8KilL9pzgaLra5vBa1I
         fGNnuinMXJr32SjbaNPCc/nA/nLu8+NYaTglU2vw803ZfpEx+g4CENmAkajurZRWdbfY
         4HpGrXSdE9W49ZeZALnMN6ZXciiU1VrvWxl+IFuzhWxNF3fMkpmJV8E+1bI32tbKBxcm
         oho41zf/cym7Kp1kn8jor5ra7ZIHN9eGiu/BmrlNHPHI46VhYaRj97CMEzKS8CWyeGmw
         Qjzg==
X-Gm-Message-State: APjAAAXQKsGqdXOg7T3x73Clx3M20GE25Fca5JicQfRKKnaQ5tPyNXji
        ws9BLZXa2JCpxVOPzqvlsX0=
X-Google-Smtp-Source: APXvYqywhigCjvf0V8jWgrcntEPT022im+5ozHdT/lBYAjP4szKy6nZXorPGKYUK8vvBZC64HEZtNQ==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr4889096pgv.243.1561659592672;
        Thu, 27 Jun 2019 11:19:52 -0700 (PDT)
Received: from localhost ([67.136.128.119])
        by smtp.gmail.com with ESMTPSA id a6sm6803714pfa.51.2019.06.27.11.19.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:19:52 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:19:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com>
Message-ID: <5d1508c79587a_e392b1ee39f65b45b@john-XPS-13-9370.notmuch>
In-Reply-To: <20190627164627.GF686@sol.localdomain>
References: <000000000000a97a15058c50c52e@google.com>
 <20190627164627.GF686@sol.localdomain>
Subject: RE: [net/tls] Re: KMSAN: uninit-value in aesti_encrypt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers wrote:
> [+TLS maintainers]
> 
> Very likely a net/tls bug, not a crypto bug.
> 
> Possibly a duplicate of other reports such as "KMSAN: uninit-value in gf128mul_4k_lle (3)"
> 
> See https://lore.kernel.org/netdev/20190625055019.GD17703@sol.localdomain/ for
> the list of 17 other open syzbot bugs I've assigned to the TLS subsystem.  TLS
> maintainers, when are you planning to look into these?
> 
> On Thu, Jun 27, 2019 at 09:37:05AM -0700, syzbot wrote:

I'm looking at this issue now. There is a series on bpf list now to address
many of those 17 open issues but this is a separate issue. I can reproduce
it locally so should have a fix soon.

Thanks,
John
