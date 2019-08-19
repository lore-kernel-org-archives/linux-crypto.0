Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACFEC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 21:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89DD0214DA
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 21:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="d9zbuePb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfHSVKO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 17:10:14 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44672 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728387AbfHSVKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 17:10:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so2696039qke.11
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gNko8uYZ/iSVAQkfn2DxMOBCbut/oBDTcq1NiXuMq1Q=;
        b=d9zbuePbVfnVj+QN/ZFdPRmQgkE8/L2bKlSBU+iTJaTACwicNRb8RIVd/OgSurHSl2
         3K/wKETiXla57BE/k/VWoPOvW9Qwmho+85Q09Wu0PiiB8JyZWKVNP3QW5DFwhLAORm6E
         egJnME5xBnx+TAu/y0VP12DBd+NSnNJcM8buHsmNZN+WcBsPmtqbmlWSW+cf5l4apqzH
         /koqgZ8IbY+5QPCVkbjXl/nBdtU+GaDAWxT7CEga7brX3Oj+Di9slysot7Pki7CrZp8x
         FSN8caxSyLv5RXg+eHlkrdrZH169XjGnlHDJUJSZdgyZwegqUtlXXqmaCkts42Sp+d3B
         LV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gNko8uYZ/iSVAQkfn2DxMOBCbut/oBDTcq1NiXuMq1Q=;
        b=Rve/bbQphP8lhfEQ984V13Zg8LsZIvONeKDU5w/GhAHOiZoetJmrXnTxK3CIbPcnYr
         gts5uqzuykXd4/HJxRT1pu0mdf+/s34b0AfAdKF5NTE79AExSFmEk5B8dcg9h+3U2hkN
         ONIb6mCfut46L1ANTwn8IT1xln4uXWJrubVJgFPSaXjDsWmXXkiD/OAy6lGkWm+Q6POt
         R/8LG7AScMucQJ6iZ+sa7y0qRy+eYCW+V+tapLycoEovaGW3/zTj2OhffVS7hY6J1Fh2
         +9KpHX8WL+5/k3Roiduti7qBGSbu6eJjTD4WIrPM5t/HsHczt53sHTPD+qipBM+BxmWb
         Meqw==
X-Gm-Message-State: APjAAAUialY1bzj4khHi2T3643BanBwbcwrlfNyRjT39B4fgb4fBttOO
        kwHCLUFGqenssLsKYATGCCjpWQ==
X-Google-Smtp-Source: APXvYqxbOHmZq2qLpckgNNtItEsJCIiUrNJX2RlAGSln7w+nCPcQfnCWxfv/mTB9PQZBdMUL2wpgYw==
X-Received: by 2002:a37:7c02:: with SMTP id x2mr23287096qkc.298.1566249008458;
        Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t13sm7579042qkm.117.2019.08.19.14.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:10:08 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:09:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+8a6df99c3b1812093b70@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Eric Biggers <ebiggers@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: INFO: task hung in tls_sw_sendmsg
Message-ID: <20190819140959.72a419d8@cakuba.netronome.com>
In-Reply-To: <0000000000006a71990583cd3d9c@google.com>
References: <0000000000006a71990583cd3d9c@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Mar 2019 01:20:05 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    d9862cfb Merge tag 'mips_5.1' of git://git.kernel.org/pub/..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16e9d977200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=73d88a42238825ad
> dashboard link: https://syzkaller.appspot.com/bug?extid=8a6df99c3b1812093b70
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: amd64
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8a6df99c3b1812093b70@syzkaller.appspotmail.com

Looks like the TLS bugs which involve pcrypt may be a pcrypt issue.
There seems to be no clear explanation for these in TLS code.

#syz dup: INFO: task hung in aead_recvmsg

This is similar to:
https://syzkaller.appspot.com/bug?id=44ae4b4fa7e6c6e92aa921d2ec20ce9fbee97939
(INFO: task hung in tls_sw_free_resources_tx)
