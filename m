From: xiakaixu <xiakaixu@huawei.com>
Subject: Re: Observed a ecryptFS crash
Date: Sun, 9 Oct 2016 15:12:29 +0800
Message-ID: <57F9EDDD.2000203@huawei.com>
References: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: liushuoran <liushuoran@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yaodongdong <yaodongdong@huawei.com>,
        Wangbintian <bintian.wang@huawei.com>,
        yingjindong <yingjindong@huawei.com>,
        Yezongbo <yezongbo@huawei.com>, "likan (A)" <likan82@huawei.com>
To: "tyhicks@canonical.com" <tyhicks@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:9818 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932129AbcJIHMx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 03:12:53 -0400
In-Reply-To: <00B10D30F2BAA743B48953A4D86C96D54CB653@SZXEMI506-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ping...


> Hi Tyhicks,
>
> We observed a ecryptFS crash occasionally in Linux kernel 4.1.18. The call trace is attached below. Is it a known issue？ Look forward to hearing from you. Thanks in advance!
>
> [19314.529479s][pid:2694,cpu3,GAC_Executor[0]]Call trace:
> [19314.529510s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000f3898>] do_raw_spin_lock+0x20/0x200
> [19314.529510s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc001031fb0>] _raw_spin_lock+0x28/0x34
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0003908e0>] selinux_inode_free_security+0x3c/0x94
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000386b04>] security_inode_free+0x2c/0x38
> [19314.529541s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001fff88>] __destroy_inode+0x2c/0x180
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000201660>] destroy_inode+0x30/0xa0
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002017d8>] evict+0x108/0x1c0
> [19314.529571s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000202588>] iput+0x184/0x258
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002f27d0>] ecryptfs_evict_inode+0x30/0x3c
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc00020177c>] evict+0xac/0x1c0
> [19314.529602s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002018d4>] dispose_list+0x44/0x5c
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000202d28>] evict_inodes+0xcc/0x12c
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e5d04>] generic_shutdown_super+0x58/0xe4
> [19314.529632s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e7164>] kill_anon_super+0x30/0x74
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0002f16a4>] ecryptfs_kill_block_super+0x24/0x54
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e6690>] deactivate_locked_super+0x60/0x8c
> [19314.529663s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0001e6754>] deactivate_super+0x98/0xa4
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000206d54>] cleanup_mnt+0x50/0xd0
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000206e48>] __cleanup_mnt+0x20/0x2c
> [19314.529693s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000c1bac>] task_work_run+0xbc/0xf8
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000a3e98>] do_exit+0x2d4/0xa14
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000a56a8>] do_group_exit+0x60/0xf8
> [19314.529724s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc0000b26ac>] get_signal+0x284/0x598
> [19314.529754s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc00008950c>] do_signal+0x170/0x5b8
> [19314.529754s][pid:2694,cpu3,GAC_Executor[0]][<ffffffc000089be0>] do_notify_resume+0x70/0x78
> [19314.529785s][pid:2694,cpu3,GAC_Executor[0]]Code: aa0003f3 aa1e03e0 97fe7718 5289d5a0 (b9400661)
> [19314.529907s][pid:2694,cpu3,GAC_Executor[0]]---[ end trace 382e4b6264b035b5 ]---
> [19314.529907s][pid:2694,cpu3,GAC_Executor[0]]Kernel panic - not syncing: Fatal exception
>
> Regards,
> Shuoran
>
