Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5E04F885
	for <linux-crypto@vger.kernel.org>; Tue, 19 Mar 2024 22:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710886767; cv=none; b=Yn51Ds4suGkn0J6KomwBc5volzXW5FirebtB/1hvVJwXDg5LLLOWq7MmuitlD1PYA3x3D3KTy47MwAJXUzmEpzomGQ+XCv1prNZZETCXjlyJGt9a0EVO+jZXjLVIneEdb/BOz12aPXDQgoSfuE5VShotpY2wKprXjIJFr/RH/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710886767; c=relaxed/simple;
	bh=o3jCWnvDkfqsEsH1ZkOdIJ7gCNPovZX350ROv8lyLQU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M8LscHZdUxUpKm+FH1/3NnxA3B26SRufPI7N0/tNp0boPtzGxTnSEWrL667TCl8pw8FR1qJei8kjCbvoSP7Xa3SrFYjSILfqfA7I+kjAbegGsd4tVxjbImq3WGZ/mZnM6pvt1v3NEgirY58MXdwe0rGA9I5uNTvk4ubsGz0s5yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dTYFJdp/; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dTYFJdp/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710886765; x=1742422765;
  h=message-id:subject:from:to:date:in-reply-to:references:
   content-transfer-encoding:mime-version;
  bh=o3jCWnvDkfqsEsH1ZkOdIJ7gCNPovZX350ROv8lyLQU=;
  b=dTYFJdp/jETVRv3iN9cX6OsGJzBDJlc5w3f3ch6wKAj/ARvOgDGBAQRp
   JGT4OXCYfQDi1eNjlg/UI3ciqNIqZGdg1Vl1pXEY34wH3U4Jk/7HqZoQq
   MqImcAIGAwLgw6pUpc41ZwEzPPg64EAtJjVyqQkkQHbOKMBBPoXiLVjP6
   kqbLY0gqLvD9WJAf0XDY+y/QLboTJWBHzlTCA3SblHSfrqt3hJOEd3l0Z
   XlLgJMQfFsgDl9OESWy3aEWYgIu1Oon2fjuAfqGU95hhuqYPGLCXD5UDW
   gDU5VJBAKmJsoSRSj2xu8jCnZM+clPr9J3cQy/UYHxuzUzoVwk2zcOCbt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16523636"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="16523636"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 15:19:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="18609700"
Received: from yyu32-mobl.amr.corp.intel.com ([10.212.107.7])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 15:19:24 -0700
Message-ID: <39f73bd559aa96051b4d5c8e42d0ce942194b64f.camel@linux.intel.com>
Subject: Re: Divide by zero in iaa_crypto during boot of a kdump kernel
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Jerry Snitselaar <jsnitsel@redhat.com>, Herbert Xu
	 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org
Date: Tue, 19 Mar 2024 17:19:22 -0500
In-Reply-To: <hyf3fggjvnjjdbkk4hvocmlfhbz2wapxjhmppurthqavgvk23m@j47q5vlzb2om>
References: 
	<hyf3fggjvnjjdbkk4hvocmlfhbz2wapxjhmppurthqavgvk23m@j47q5vlzb2om>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Jerry,

On Tue, 2024-03-19 at 13:51 -0700, Jerry Snitselaar wrote:
> Hi Tom,
>=20
> While looking at a different issue on a GNR system I noticed that
> during the boot of the kdump kernel it crashes when probing
> iaa_crypto
> due to a divide by zero in rebalance_wq_table. The problem is that
> the
> kdump kernel comes up with a single cpu, and if there are multiple
> iaa
> devices cpus_per_iaa is going to be calculated to be 0, and then the
> 'if ((cpu % cpus_per_iaa) =3D=3D 0)' in rebalance_wq_table results in a
> divide by zero. I reproduced it with the 6.8 eln kernel, and so far
> have reproduced it on GNR, EMR, and SRF systems. I'm assuming the
> same
> will be the case on and SPR system with IAA devices enabled if I can
> find one.
>=20

Good catch, I've never tested that before. Thanks for reporting it.

> Should save_iaa_wq return an error if the number of iaa devices is
> greater
> than the number of cpus?
>=20

No, you should still be able to use the driver with just one cpu, maybe
it just always maps to the same device. I'll take a look and come up
with a fix.

Tom

>=20
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.242696] idxd: crypto: iaa_crypto now =
ENABLED
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.248641] divide error: 0000 [#1] PREEM=
PT SMP NOPTI
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.254358] CPU: 0 PID: 396 Comm: systemd=
-udevd Not tainted
> 6.8.0-63.eln136.1.x86_64 #1
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.263399] Hardware name: Intel Corporat=
ion
> AvenueCity/AvenueCity, BIOS BHSDCRB1.IPC.2780.D02.2311070514
> 11/07/2023
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.275266] RIP: 0010:rebalance_wq_table.=
part.0+0x163/0x220
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.282851] Code: 85 c0 74 c1 8b 35 6d ed=
 f3 c2 31 db 48 39 f3
> 73 4d 48 89 da 4c 89 f7 e8 9b 5a 26 c1 3b 05 55 ed f3 c2 89 c6 73 38
> 31 d2 89 d8 <f7> 35 9f 76 00 00 83 fa 01 41 83 d5 00 44 89 ef e8 68
> f9 ff ff 85
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.303974] RSP: 0018:ffa0000001147bb0 EF=
LAGS: 00010246
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.309895] RAX: 0000000000000000 RBX: 00=
00000000000000 RCX:
> 00000000ffffffff
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.317956] RDX: 0000000000000000 RSI: 00=
00000000000000 RDI:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.326016] RBP: 0000000000000000 R08: 00=
00000000000000 R09:
> 0000000000000001
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.334076] R10: ff1100005bff93c0 R11: 00=
00000000000003 R12:
> ffffffff826cbba8
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.342137] R13: 00000000ffffffff R14: ff=
1100005bff93c0 R15:
> ff110000563968e0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.350197] FS:=C2=A0 00007f0697de8540(00=
00)
> GS:ff1100005ba00000(0000) knlGS:0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.359333] CS:=C2=A0 0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.365834] CR2: 000055bf003ad358 CR3: 00=
00000046632003 CR4:
> 0000000000f71eb0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.373900] DR0: 0000000000000000 DR1: 00=
00000000000000 DR2:
> 0000000000000000
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.381960] DR3: 0000000000000000 DR6: 00=
000000fffe07f0 DR7:
> 0000000000000400
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.390020] PKRU: 55555554
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.393113] Call Trace:
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.395905]=C2=A0 <TASK>
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.398310]=C2=A0 ? die+0x36/0x90
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.401600]=C2=A0 ? do_trap+0xda/0x100
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.405373]=C2=A0 ? rebalance_wq_table.pa=
rt.0+0x163/0x220
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.412265]=C2=A0 ? do_error_trap+0x65/0x=
80
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.416519]=C2=A0 ? rebalance_wq_table.pa=
rt.0+0x163/0x220
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.423412]=C2=A0 ? exc_divide_error+0x38=
/0x50
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.427970]=C2=A0 ? rebalance_wq_table.pa=
rt.0+0x163/0x220
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.434861]=C2=A0 ? asm_exc_divide_error+=
0x1a/0x20
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.439805]=C2=A0 ? rebalance_wq_table.pa=
rt.0+0x163/0x220
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.446696]=C2=A0 iaa_crypto_probe+0x117/=
0x2e0 [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.452514]=C2=A0 really_probe+0x19b/0x3e=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.456674]=C2=A0 ? __pfx___driver_attach=
+0x10/0x10
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.461715]=C2=A0 __driver_probe_device+0=
x78/0x160
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.466659]=C2=A0 driver_probe_device+0x1=
f/0xa0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.471313]=C2=A0 __driver_attach+0xba/0x=
1c0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.475665]=C2=A0 bus_for_each_dev+0x8c/0=
xe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.480028]=C2=A0 bus_add_driver+0x116/0x=
220
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.484380]=C2=A0 driver_register+0x5c/0x=
100
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.488731]=C2=A0 iaa_crypto_init_module+=
0xe5/0xff0 [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.495043]=C2=A0 ? __pfx_iaa_crypto_init=
_module+0x10/0x10
> [iaa_crypto]
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.502032]=C2=A0 do_one_initcall+0x58/0x=
310
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.506385]=C2=A0 do_init_module+0x60/0x2=
40
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.510640]=C2=A0 __do_sys_init_module+0x=
17a/0x1b0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.515587]=C2=A0 do_syscall_64+0x81/0x16=
0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.519746]=C2=A0 ? handle_mm_fault+0xdd/=
0x360
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.524302]=C2=A0 ? do_user_addr_fault+0x=
2fe/0x670
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.529248]=C2=A0 ? exc_page_fault+0x6b/0=
x150
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.533697]=C2=A0 entry_SYSCALL_64_after_=
hwframe+0x6e/0x76
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.539413] RIP: 0033:0x7f0698a2ef1e
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.543479] Code: 48 8b 0d 05 af 0e 00 f7=
 d8 64 89 01 48 83 c8
> ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 af 00
> 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d2 ae 0e 00 f7 d8
> 64 89 01 48
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.564605] RSP: 002b:00007ffe27da0918 EF=
LAGS: 00000246
> ORIG_RAX: 00000000000000af
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.573156] RAX: ffffffffffffffda RBX: 00=
0055beffb45cb0 RCX:
> 00007f0698a2ef1e
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.581216] RDX: 000055beffb78ba0 RSI: 00=
00000000026400 RDI:
> 000055bf00386cf0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.589276] RBP: 000055bf00386cf0 R08: 00=
0055beffb70340 R09:
> 0000000000026010
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.597337] R10: 0000000000000005 R11: 00=
00000000000246 R12:
> 000055beffb78ba0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.605397] R13: 000055beffb71110 R14: 00=
00000000000000 R15:
> 000055beffb45fe0
> =C2=A0=C2=A0=C2=A0 [=C2=A0=C2=A0 17.613459]=C2=A0 </TASK>
>=20
>=20
> Regards,
> Jerry
>=20

