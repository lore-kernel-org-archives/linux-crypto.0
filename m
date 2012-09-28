From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: aesni intel and kernel crashes.
Date: Fri, 28 Sep 2012 15:41:50 +0300
Message-ID: <20120928154150.178522ssx9low1es@www.81.fi>
References: <CA+sc+0T3CFwv6JdcLA66=pD=6LcaQOJZnvDGqp3o4LKN85ZbZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:42557 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab2I1Mlx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Sep 2012 08:41:53 -0400
In-Reply-To: <CA+sc+0T3CFwv6JdcLA66=pD=6LcaQOJZnvDGqp3o4LKN85ZbZg@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Gurucharan Shetty <gurucharan.shetty@gmail.com>:

> Hello All,
>
>  I have been seeing a bunch of kernel crashes while using aesni_intel
> module and IPSEC.
*snip*
>  #6 [ffff880c0fc63998] cryptd_enqueue_request at ffffffffa02d9106 [cryptd]
>  #7 [ffff880c0fc639c8] cryptd_aead_decrypt_enqueue at  
> ffffffffa02d92c0 [cryptd]
>  #8 [ffff880c0fc639d8] rfc4106_decrypt at ffffffffa02ec2bf [aesni_intel]
>  #9 [ffff880c0fc63a08] esp_input at ffffffffa029da65 [esp4]
> #10 [ffff880c0fc63a98] xfrm_input at ffffffff815cb9c4
> #11 [ffff880c0fc63b08] xfrm4_rcv_encap at ffffffff815c148c
> #12 [ffff880c0fc63b18] xfrm4_rcv at ffffffff815c14b4
> #13 [ffff880c0fc63b28] ip_local_deliver_finish at ffffffff815749ed
> #14 [ffff880c0fc63b58] ip_local_deliver at ffffffff81574d58
> #15 [ffff880c0fc63b88] ip_rcv_finish at ffffffff815746c1
> #16 [ffff880c0fc63bb8] ip_rcv at ffffffff81574f95
> #17 [ffff880c0fc63bf8] __netif_receive_skb at ffffffff81540523
> #18 [ffff880c0fc63c58] netif_receive_skb at ffffffff81541300
> #19 [ffff880c0fc63c88] napi_skb_finish at ffffffff81541450
> #20 [ffff880c0fc63ca8] napi_gro_receive at ffffffff81541a55
> #21 [ffff880c0fc63ce8] bnx2x_rx_int at ffffffffa01850c8 [bnx2x]
> #22 [ffff880c0fc63e18] bnx2x_poll at ffffffffa0187409 [bnx2x]
> #23 [ffff880c0fc63e68] net_rx_action at ffffffff81541ca4
> #24 [ffff880c0fc63ed8] __do_softirq at ffffffff8106ea58
> #25 [ffff880c0fc63f48] call_softirq at ffffffff8166422c
> #26 [ffff880c0fc63f60] do_softirq at ffffffff81015305
> #27 [ffff880c0fc63f80] irq_exit at ffffffff8106ee3e
> #28 [ffff880c0fc63f90] smp_apic_timer_interrupt at ffffffff81664bce
> #29 [ffff880c0fc63fb0] apic_timer_interrupt at ffffffff81662a9e
> --- <IRQ stack> ---
> #30 [ffff880bedd939f0] apic_timer_interrupt at ffffffff81662a9e
>     RIP: ffffffffffffff10  RSP: 0000000000000202  RFLAGS: 00000010
>     RAX: 00007ffffffff000  RBX: ffff880bedd93ac8  RCX: ffff880bee255bc0
>     RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000001
>     RBP: ffffffff8103dcf9   R8: 000000000000007d   R9: 0000000000000000
>    R10: 0000000000000011  R11: ffffffff81659c5e  R12: ffff880bedd93a18
>     R13: 0044b82fa09b5a53  R14: ffff880bedd93a3e  R15: 000000000000003a
>     ORIG_RAX: ffff880bedd41888  CS: ffffffff810b2a4f  SS: ffff880bedd93aa8
*snip*
> [ 3673.935620] Process kworker/3:1 (pid: 125, threadinfo
> ffff880bedd92000, task ffff880bee255bc0)
> [ 3673.935697] Stack:
> [ 3673.935747]  ffffffffa02d9b46 ffff880bedd93e60 ffffe8f3cfc61f10
> ffff880bee3e1200
> [ 3673.935954]  ffff880c0fc7aa00 ffff880bedd93e70 ffffffff81084f9a
> ffff880bedd93fd8
> [ 3673.936161]  0000000000013780 ffff880bee2916f0 ffff880bee255bc0
> ffff880c0fc7aa05
> [ 3673.936367] Call Trace:
> [ 3673.936421]  [<ffffffffa02d9b46>] ? cryptd_queue_worker+0x56/0x80 [cryptd]
> [ 3673.936486]  [<ffffffff81084f9a>] process_one_work+0x11a/0x480
> [ 3673.936546]  [<ffffffff81085d44>] worker_thread+0x164/0x370
> [ 3673.936605]  [<ffffffff81085be0>] ? manage_workers.isra.29+0x130/0x130
> [ 3673.936666]  [<ffffffff8108a59c>] kthread+0x8c/0xa0
> [ 3673.936725]  [<ffffffff81664134>] kernel_thread_helper+0x4/0x10
> [ 3673.936785]  [<ffffffff8108a510>] ? flush_kthread_worker+0xa0/0xa0
> [ 3673.936844]  [<ffffffff81664130>] ? gs_change+0x13/0x13

cryptd uses get_cpu/put_cpu in cryptd_enqueue_request and  
preempt_disable/preempt_enable in cryptd_queue_worker to protect  
cpu_queue->queue. However cryptd_enqueue_request is called from  
interrupt context. That probably is source of the problem.

-Jussi
