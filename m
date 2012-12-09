From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: crypto: Kernel crashes at crypto_alg_mod_lookup
Date: Sun, 09 Dec 2012 22:09:29 +0200
Message-ID: <20121209220929.71081xj6vxxlm5us@www.dalek.fi>
References: <CANR7ExJ1bjf7X_Lhn_UBKrq10C0g3T9E6Fdpp52wjxav532rZw@mail.gmail.com>
 <20121130184653.75996106ogbcmg3h@www.dalek.fi>
 <CANR7ExJvMgO3O_y69USFwBccVN8Y4hbQYTF7H1YEK44nAq-8cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Guru Shetty <gurushettylists@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:44618 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab2LIUJe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Dec 2012 15:09:34 -0500
In-Reply-To: <CANR7ExJvMgO3O_y69USFwBccVN8Y4hbQYTF7H1YEK44nAq-8cA@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Guru Shetty <gurushettylists@gmail.com>:

>
> Thanks for looking into this. I reproduced it a few more times.
>
> When the machine boots up and the strongswan daemon is started, it
> triggers the loading of the
> following kernel modules.
>
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/ipv4/ah4.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/ipv4/esp4.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/xfrm/xfrm_ipcomp.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/ipv4/ipcomp.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/ipv4/tunnel4.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/ipv4/xfrm4_tunnel.ko
> insmod /lib/modules/3.2.14-server-nn19+/kernel/net/xfrm/xfrm_user.ko
>
> After the last kernel module is loaded, the backtrace is printed on
> the screen. It could be that
> the kernel modules are all loaded fine and it is a system call that
> triggers this bug as shown in
> the trace.
>
> Does adding any printk messages and doing a few reboots help
> in providing any more information?
>

I think modules are loading fine. Problem might be related to nested  
crypto allocations with aesni-intel. You could try kernel with  
"CONFIG_DEBUG_LIST=y" config setting, for more output.

-Jussi
