Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061E6C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 23:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7EA12146F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 23:01:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVCUjS9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDKXBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 19:01:01 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43503 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDKXBB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 19:01:01 -0400
Received: by mail-ed1-f65.google.com with SMTP id w3so6664417edu.10;
        Thu, 11 Apr 2019 16:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoGIeW48yb03moGZTb/AxQdYJpUjFMLX0v9MuEKlPhM=;
        b=KVCUjS9MgPX7m7iy97B+vSUJcJkOrlGECOLv0Di/1dSpJ7myfY2qfVkrjsVnWRF2oH
         LZFaSLXNyJ2maYDI+ZANGCiRHQbN9uuuNro5FizkjYtO3AeLrDlm6CczsI5L7d/Gq52c
         OAVM0MaEJ+wxfGuV56+7c36BTE064j01kZZLLq4QSKADUhqnCZCuv3ehp7fD69LrQW9M
         M7TQki+jYtdW0gayo0knq5T+PhaJGFAlYTa32fIilKPEcRYJFzqrmilVFAITAo3EG56H
         xSTMxujw7iyLYxv7txxSncJd73onfpeL3xS5NrB1WMkMsPzho/FjirC/YD1BQEpFQAwJ
         7rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoGIeW48yb03moGZTb/AxQdYJpUjFMLX0v9MuEKlPhM=;
        b=pZmbfkLchA/55j4pDEDbiJ5pB8LKc4oTlost0BeG9I/7BY0K/AqKjRHn3/QmdIALtr
         2rhxF5o1NK25Mip6yM2H6wgoiXY57S0US94AUCUUni5r14KFq1JlihQWR2BuE/DdQp66
         /Bk/5u/7qPHig+kco+gzl5BG0TdYc8/lR7wEQU/X/aMTPfu/Q4Msi7VBNeg1mVXJ4tr6
         ryrkMcjICxP4B0gEQHW7fQu2YepX4kr7W/QIg7HnrOpAnLd8YRhhaI+h0fzKx1yZd3LB
         Ysfq4RWK8TklX/Gtxs6uDVYk/cY/wbMeVuReJozg9AgHHGCrTS7CbEPHkM41BnMH42FW
         QtgQ==
X-Gm-Message-State: APjAAAUFzwOX3LgEJ4OeKXdKrcqJI1qYPQ5qEYwFzyhox3NHy5egyWst
        moB/FmQCU4QYlBGiSYbCL3lOsTsz4dp402H566w=
X-Google-Smtp-Source: APXvYqysvb/u6xgKh2oV6/Vdm9wj1dRqtNEnXFiF0LJ49D3mweMA4VMeZRtX6j2YDqaURMm+dd4XVfDlIwHmYEWC7Lw=
X-Received: by 2002:a50:f983:: with SMTP id q3mr26818782edn.270.1555023659420;
 Thu, 11 Apr 2019 16:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190409152540.11729-1-atul.gupta@chelsio.com> <201904120528.DTQt9Vn4%lkp@intel.com>
In-Reply-To: <201904120528.DTQt9Vn4%lkp@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 11 Apr 2019 19:00:23 -0400
Message-ID: <CAF=yD-+yfcvLhm6XcG-bBP6dn7-=GUJqWUPCZop5VQNra+y8CQ@mail.gmail.com>
Subject: Re: [crypto 4/4] IPv6 changes for Inline TLS
To:     kbuild test robot <lkp@intel.com>
Cc:     Atul Gupta <atul.gupta@chelsio.com>, kbuild-all@01.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>, dt@chelsio.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 6:06 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Atul,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on crypto/master]
>
> url:    https://github.com/0day-ci/linux/commits/Atul-Gupta/Inline-TLS-client-and-v6-support/20190412-034407
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> config: mips-allmodconfig (attached as .config)
> compiler: mips-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.2.0 make.cross ARCH=mips
>
> All warnings (new ones prefixed by >>):
>
>    In file included from drivers/crypto/chelsio/chtls/chtls_main.c:19:0:
> >> include/net/transp_v6.h:52:33: warning: 'struct ipcm6_cookie' declared inside parameter list will not be visible outside of this definition or declaration
>          struct flowi6 *fl6, struct ipcm6_cookie *ipc6);
>                                     ^~~~~~~~~~~~

The header file does not include every header it depends on. This is
not the only instance, but if the only one that triggers, perhaps
easiest is to add a forward declaration.

diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index a8f6020f1196e..fef338b08e0fa 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -12,6 +12,7 @@ extern struct proto tcpv6_prot;
 extern struct proto pingv6_prot;

 struct flowi6;
+struct ipcm6_cookie *ipc6;

I can send a separate patch to net-next. But since this patch already
changes that file, I would suggest including the one line change in a
v2 here.


> --
>    drivers/crypto/chelsio/chtls/chtls_cm.c: In function 'chtls_pass_accept_request':
> >> drivers/crypto/chelsio/chtls/chtls_cm.c:2272:8: warning: 'eh' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       ip6h = (struct ipv6hdr *)(eh + 1);
>       ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/crypto/chelsio/chtls/chtls_cm.c: In function 'chtls_v6_connect':
> >> drivers/crypto/chelsio/chtls/chtls_cm.c:1552:12: warning: 'saddr' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      fl6.saddr = saddr ? *saddr : np->saddr;
>      ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> vim +52 include/net/transp_v6.h
>
> f145b67f2 Joe Perches          2013-06-02  42
> 4b261c75a Hannes Frederic Sowa 2014-01-20  43  /* this does all the common and the specific ctl work */
> 4b261c75a Hannes Frederic Sowa 2014-01-20  44  void ip6_datagram_recv_ctl(struct sock *sk, struct msghdr *msg,
> 4b261c75a Hannes Frederic Sowa 2014-01-20  45                      struct sk_buff *skb);
> 4b261c75a Hannes Frederic Sowa 2014-01-20  46  void ip6_datagram_recv_common_ctl(struct sock *sk, struct msghdr *msg,
> 4b261c75a Hannes Frederic Sowa 2014-01-20  47                             struct sk_buff *skb);
> 4b261c75a Hannes Frederic Sowa 2014-01-20  48  void ip6_datagram_recv_specific_ctl(struct sock *sk, struct msghdr *msg,
> ^1da177e4 Linus Torvalds       2005-04-16  49                               struct sk_buff *skb);
> ^1da177e4 Linus Torvalds       2005-04-16  50
> f145b67f2 Joe Perches          2013-06-02  51  int ip6_datagram_send_ctl(struct net *net, struct sock *sk, struct msghdr *msg,
> 5fdaa88df Willem de Bruijn     2018-07-06 @52                     struct flowi6 *fl6, struct ipcm6_cookie *ipc6);
> ^1da177e4 Linus Torvalds       2005-04-16  53
>
> :::::: The code at line 52 was first introduced by commit
> :::::: 5fdaa88dfefa87ee1ea92750e99950dca182ea41 ipv6: fold sockcm_cookie into ipcm6_cookie
>
> :::::: TO: Willem de Bruijn <willemb@google.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
