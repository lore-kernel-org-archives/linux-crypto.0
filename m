From: Fabio Estevam <festevam@gmail.com>
Subject: Re: mxs-dcp: BUG: init/1 still has locks held!
Date: Sun, 11 May 2014 17:09:27 -0300
Message-ID: <CAOMZO5Bh9E5Y53TVhHPE=Zo9K47xgwz-Axx9d55YFcRH+_fV8Q@mail.gmail.com>
References: <CAOMZO5AdHCsCXW-WhRpkZJJcsmoQKvob_zhx-7fu8RSim5-dQA@mail.gmail.com>
	<1399838888.578955384@f427.i.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	=?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Shawn Guo <shawn.guo@freescale.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Alexander Shiyan <shc_work@mail.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:35295 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758398AbaEKUJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 May 2014 16:09:28 -0400
Received: by mail-ve0-f182.google.com with SMTP id sa20so7700460veb.41
        for <linux-crypto@vger.kernel.org>; Sun, 11 May 2014 13:09:27 -0700 (PDT)
In-Reply-To: <1399838888.578955384@f427.i.mail.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 11, 2014 at 5:08 PM, Alexander Shiyan <shc_work@mail.ru> wr=
ote:
> Sun, 11 May 2014 16:57:57 -0300 =D0=BE=D1=82 Fabio Estevam <festevam@=
gmail.com>:
>> Hi,
>>
>> Running linux-next 20140509 on a mx28evk I observe the following war=
ning:
>>
>> [    8.526613] Freeing unused kernel memory: 232K (c0683000 - c06bd0=
00)
>> starting pid 56, tty '': '/etc/rc.d/rcS'
>> [    9.110314]
>> [    9.111864] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [    9.116603] [ BUG: init/1 still has locks held! ]
>> [    9.121488] 3.15.0-rc4-next-20140509-00001-g319564e #1154 Not tai=
nted
>> [    9.128071] -------------------------------------
>> [    9.132825] 1 lock held by init/1:
>> [    9.136252]  #0:  (global_mutex){+.+.+.}, at: [<c0387d68>] mxs_dc=
p_probe+0x14
>> [    9.144196]
>> [    9.144196] stack backtrace:
>> [    9.148888] CPU: 0 PID: 1 Comm: init Not tainted 3.15.0-rc4-next-=
20140509-004
>> [    9.157610] [<c000da40>] (unwind_backtrace) from [<c000bda4>] (sh=
ow_stack+0x)
>> [    9.165595] [<c000bda4>] (show_stack) from [<c00153d4>] (do_fork+=
0x2c8/0x3cc)
>> [    9.172921] [<c00153d4>] (do_fork) from [<c0015550>] (sys_vfork+0=
x20/0x2c)
>> [    9.179973] [<c0015550>] (sys_vfork) from [<c0009580>] (ret_fast_=
syscall+0x0)
>> Mounting /proc and /sys
>>
>> Should we really use a global mutex here? What is a proper fix for t=
his?
>
> On my opinion mutex_lock/unlock should not be used in probe.
> Try to remove this entirely.

I think the same. Will submit a patch doing as suggested.

Regards,

=46abio Estevam
