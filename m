Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FCB2BEC27
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772815070; cv=none; b=nEaSgqvwaCYyqqrNxVXrGypmSWCffTmj/uF+hhayrnU4JjxZPinREl5sc6iW8MxpYEnPVo2ekRO6GA3XuBxJTtzWhLFvlEEe+zhGahnZe+YUIXyzk649ClCIlWEABb0YUnfbAt2SN4oBKmlvBlThnqkcztX2r8lF/oMc9YNKw/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772815070; c=relaxed/simple;
	bh=JHj2OY6d8eKbQeRapfnCJ+S/9OtFltd8Xt0exu2oABo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpxVI3lPm/1FDVj58aWN2Xz71SKe7R56UxX+/TiajYH6Y8mPwm5l3k1zK4yuAcRcAUg0lUR+yKz+mKjhYGrzhk0KKo64b/CAsBR4Zn3LteuKQmUvV3+VGBuIyEDtaYBPq+IKagCPL3eI6+En8kWEhgITwbQo9Yz60U+16BQ7Deo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P1FKTYVy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HkYs3Fkh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P1FKTYVy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HkYs3Fkh"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626FqvjV1742884
	for <linux-crypto@vger.kernel.org>; Fri, 6 Mar 2026 16:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GAQ9pLciHvE
	89gx35mXrNVxSf1XEwFKPuDx6QiEHunQ=; b=P1FKTYVyaDTRWBui++G0QZpvcf3
	kRJUM5T8j7aH3DAqhO9UFO8Ln03Jxu8mO4M/T/jwUhy4YoHS9jxS6n7vPzw8e362
	71SnrJLpEQtBWBWm1ij/sp+hZyv8gsmmgRPiMnh+gMd02+53V5JwxKvGq49FdeH2
	ocyG2/0uwDG6u73p0UwkMpvPZRvcq26z8gr+1aVCF1nqMINH5RKc0Pwq6SkUO9Vs
	Y7BYlpOe/uXWlUmHPn8byD6p3BTzuIKWgY4xZK18rSotEzHQl6zKzFxRxG7KOi+9
	uWUT7XGpYMcblNJThe34GwGIXOjy/NLVtTvvo0V3NEL0LvnrIcLwM5lT4bg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqx14gyc0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 16:37:47 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cb390a0c4eso5820660085a.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2026 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772815066; x=1773419866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAQ9pLciHvE89gx35mXrNVxSf1XEwFKPuDx6QiEHunQ=;
        b=HkYs3FkhujN1/f0I+btKCFlWveB2ySHXuasO6tTMNfRQTCzG76b0DaKG6V7CTPeiOX
         /4vjeQrE5WIs3c9d6jNiPm5b0FVupCn0mLuEOiAf4puwwe9sr8Lz7jKeDOgEoeKK9LbS
         9UqVCc35D/cYR6uH5vl9JkZpoGJBXdJsgN06CnpRw/uZGGs4Sa7Vqhis1cPq5hvpLjx0
         qNhNhoi9r2G8/uo2UN4Ad5NbkhFF2yRT5F/R+7vhbCAlleLsIqPu8abuRRO/QKdXGvek
         AII0hZmVFTGFXynfj5gZ4OzW61AnuB+hP5HVJk+RQJ4HmyzL13jG//IwmHD3tsjAskLm
         JfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772815066; x=1773419866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GAQ9pLciHvE89gx35mXrNVxSf1XEwFKPuDx6QiEHunQ=;
        b=AEr88gyCI4ZskcJHOYeF0imi6ufJIOgk2ORDh3cH5VTbP4yqPUTSNGqpS0VlhyNH1Z
         6lkuDEDPnBIoZ/j7qMkMg6DjY/YnVq0sUtXgauWwglZuWPP1G0RO1NUaChQ+nVbneXna
         dWRjrJEnQ+RYnVlmmMNJFdO/U8Kn13akuSnhG93kZrjPOrKNWAD+D90H8B7dkDQ8azQF
         lNr/aumCtz+8ItCjhwj/Bq1EGqNJtZmEtmlA/v+OL7NlprxVuFqefZWHQYJteQoMUdCf
         XHPsnOhpZfi8TP2SZTgDVN1L6WcTjY2sIijYH+6chECGfSZaluaLSTSosqw99UntOi8T
         q+bw==
X-Forwarded-Encrypted: i=1; AJvYcCU44N2w0OVS2ws2TdH6BXMBKor3HwrlO1WPzoT5unRj8NUJuITlHfDxfXuohpbuOUdQKROAbd1pvW61yss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFh8RLiMCh0GMLJhFzI61VbZFWmNjN53gAVr5QiLEd1/RE6bow
	t3pBFnp1Yul23a8T413aImRjdyZTKm+KqIM3EPS0k+hp0+gaDoCgRD1Qic0wCH0uQHYeqjb/jJr
	n4U2ny0ZplswLB2lafs5YRwU9SwkUqE0e2IUHbKj4Oi1qtK5EX26z/bzywAD2r+wkKWlYjOs3E/
	fG0w==
X-Gm-Gg: ATEYQzyMaKkEqsrcvPW54fbmzV3yfddFLuGYus+65hIbWU9N06n8qQGjmMJClymbKtY
	9MCp87UVjjdvH7ovOif/VJipqa2QpKoSs+AgfjBR9vVsIY4MJcgvY8aefn83ouE7qM7IlVEyIW8
	CX8RpgOiMRr4YC1hXOVflA0slNYCD1nYMppQXihm8FSqyKQciAUesrOs6x6MQ+3f9LRUIzvUMJr
	n38gvRe30GJJpPjdipt3qNM2gkgvtR7K/j2at7w27rG6yGtb1UMiRCKGbm5xBNxjNzHuySZMSIg
	XeeV9qCrgdaIUpRpukZG+GjhUqEmsxxE5Ep0H1vaQ7FJrX1Wjjje+s1QY7YV1ro4dwNvXk2+bm8
	AJfHcJqPtYkDXKV4y2scFq3wVb6hInxIyZ8465wduI1a5HM21HWUTfI9maBYVOw==
X-Received: by 2002:a05:620a:489b:b0:8c7:155a:6d03 with SMTP id af79cd13be357-8cd6d4e70b4mr377711885a.58.1772815066073;
        Fri, 06 Mar 2026 08:37:46 -0800 (PST)
X-Received: by 2002:a05:620a:489b:b0:8c7:155a:6d03 with SMTP id af79cd13be357-8cd6d4e70b4mr377707685a.58.1772815065512;
        Fri, 06 Mar 2026 08:37:45 -0800 (PST)
Received: from hu-yabdulra-ams.qualcomm.com ([212.136.9.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851fb3666asm112694935e9.14.2026.03.06.08.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 08:37:44 -0800 (PST)
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
To: ebiggers@kernel.org
Cc: amadeuszx.slawinski@linux.intel.com, arnd@arndb.de, dakr@kernel.org,
        gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org, rafael@kernel.org,
        russ.weight@linux.dev, jeff.hugo@oss.qualcomm.com,
        troy.hanson@oss.qualcomm.com
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of crypto_shash API
Date: Fri,  6 Mar 2026 17:37:43 +0100
Message-ID: <20260306163744.1495881-1-youssef.abdulrahman@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250428190909.852705-1-ebiggers@kernel.org>
References: <20250428190909.852705-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE1NyBTYWx0ZWRfX+JiqsRmAX42M
 v8KHb0c6gAzQnm3oRBzFovwPgEJC8EAFpnTa5g6mou4LvuvTaVaswcomkl8V5zY6C6lSb08l+MR
 2yFST6oGrYzekpqItRDS/CaEuuNa0+8aYbiEeVgJTN4nH1pjReIR4r0vPT8WLNj/Ki9kFoK6sS5
 NCf8+0hYAZgYxUQgp68CeILzxcLCzKPVYXTQMyeligKaAOmKs0UXgcdAjTNXxhWveSUyvUOa2Gm
 g+CGZWkDXuHRsiXnSoqxyARoQv//siEyCjWPkg5TfdoAPMHBfG1iPxkjRzYyrHwbgz80Q44orHP
 TYj5j0T9CeqfeER3acXcKDtyxZAPPGj6JPQGvkgfyMPArlWsHpFjah6zFiC2UvlVBx1401+Ys9Z
 xa4PAcdViEU3Yz4/ef/iexmnQzQbiE2RoNj96RyrDE/g0AKhGTb6e7Ct2tSPHJHr+9rWPq+/qQo
 v/9ng5yJVA4S5ChWkTQ==
X-Proofpoint-GUID: iDTgaOPT8JZAdndZZVIVmM7_DAwoW3wu
X-Proofpoint-ORIG-GUID: iDTgaOPT8JZAdndZZVIVmM7_DAwoW3wu
X-Authority-Analysis: v=2.4 cv=e/MLiKp/ c=1 sm=1 tr=0 ts=69ab02db cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=dNlqnMcrdpbb+gQrTujlOQ==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=FNyBlpCuAAAA:8 a=1XWaLZrsAAAA:8 a=RQVng53ib3JEPYZLgFUA:9
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1011 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060157

On 4/28/2025 8:09 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> This user of SHA-256 does not support any other algorithm, so the
> crypto_shash abstraction provides no value.  Just use the SHA-256
> library API instead, which is much simpler and easier to use.
>=20
> Also take advantage of printk's built-in hex conversion using %*phN.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>=20
> This patch is targeting the firmware_loader tree for 6.16.
Hi Eric,

An issue has been found on kernel versions older than v6.16, where a firmwa=
re
file larger than 2GB and is not divisible by SHA256_BLOCK_SIZE (64b) will a=
lways lead to a page fault. The first size that fits this criteria is 21474=
83649b. It is also worth noting that any subsequent loads regardless of the=
 size or divisibility by 64, will lead to another page fault.
I've mainly tested this with drivers/accel/qaic on 6.8.0-62-generic, but te=
chnically this should affect any code that uses the firmware loader on a ke=
rnel version older than v6.16 with CONFIG_FW_LOADER_DEBUG enabled, includin=
g the stable kernels.

This can be reproduced by creating a dummy binary file of a size that fits =
the criteria listed above, then compress it using zstd to allow _request_fi=
rmware() to open it.

This patch appears to have fixed the issue so I suggest backporting it, but
I also noticed that it relies on changes that were introduced in this serie=
s:
https://lore.kernel.org/lkml/cover.1745734678.git.herbert@gondor.apana.org.=
au/

Below is the BUG splat:

[1667258.914177] BUG: unable to handle page fault for address: ffffb731b3fb=
cd40
[1667258.914188] #PF: supervisor read access in kernel mode
[1667258.914193] #PF: error_code(0x0000) - not-present page
[1667258.914198] PGD 100000067 P4D 100000067 PUD 1002d4067 PMD 529eec067 PT=
E 0
[1667258.914208] Oops: 0000 [#3] PREEMPT SMP PTI
[1667258.914214] CPU: 11 PID: 1252644 Comm: kworker/11:1 Tainted: P      D =
W  OE      6.8.0-62-generic #65-Ubuntu
[1667258.914223] Hardware name: Wiwynn Twin Lakes MP/Twin Lakes Passive MP,=
 BIOS YMGPE07 12/23/2019
[1667258.914229] Workqueue: events sahara_processing [qaic]
[1667258.914257] RIP: 0010:memcpy_orig+0x105/0x130
[1667258.914267] Code: 0f 1f 44 00 00 83 fa 04 72 1b 8b 0e 44 8b 44 16 fc 8=
9 0f 44 89 44 17 fc c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 83 ea 01 72 19 <=
0f> b6 0e 74 12 4c 0f b6 46 01 4c 0f b6 0c 16 44 88 47 01 44 88 0c
[1667258.914278] RSP: 0018:ffffb731a3c57c78 EFLAGS: 00010202
[1667258.914284] RAX: ffffa0ac564f41b0 RBX: ffffa0ac564f41b0 RCX: 00000000d=
7af7212
[1667258.914290] RDX: 0000000000000001 RSI: ffffb731b3fbcd40 RDI: ffffa0ac5=
64f41b0
[1667258.914295] RBP: ffffb731a3c57ca8 R08: 000000005ab6c582 R09: 000000007=
2a12f7b
[1667258.914301] R10: 0000000064f65b73 R11: 000000001cb47ae9 R12: ffffffff9=
3d71d40
[1667258.914306] R13: ffffb731b3fbcd40 R14: 0000000000000002 R15: ffffb7322=
024b000
[1667258.914311] FS:  0000000000000000(0000) GS:ffffa0bb7f580000(0000) knlG=
S:0000000000000000
[1667258.914318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1667258.914323] CR2: ffffb731b3fbcd40 CR3: 0000000b09e3c005 CR4: 000000000=
07706f0
[1667258.914329] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[1667258.914334] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
[1667258.914339] PKRU: 55555554
[1667258.914342] Call Trace:
[1667258.914346]  <TASK>
[1667258.914350]  ? show_regs+0x6d/0x80
[1667258.914358]  ? __die+0x24/0x80
[1667258.914364]  ? page_fault_oops+0x99/0x1b0
[1667258.914372]  ? kernelmode_fixup_or_oops.isra.0+0x69/0x90
[1667258.914380]  ? __bad_area_nosemaphore+0x19e/0x2c0
[1667258.914388]  ? bad_area_nosemaphore+0x16/0x30
[1667258.914394]  ? do_kern_addr_fault+0x7b/0xa0
[1667258.914400]  ? exc_page_fault+0x1a4/0x1b0
[1667258.914407]  ? asm_exc_page_fault+0x27/0x30
[1667258.914417]  ? memcpy_orig+0x105/0x130
[1667258.914425]  ? lib_sha256_base_do_update.isra.0+0x5d/0x1d0 [sha256_sss=
e3]
[1667258.914433]  ? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
[1667258.914440]  sha256_finup+0xf5/0x150 [sha256_ssse3]
[1667258.914447]  sha256_avx2_digest+0x55/0x70 [sha256_ssse3]
[1667258.914453]  crypto_shash_digest+0x2a/0x60
[1667258.914460]  fw_log_firmware_info+0x113/0x1b0
[1667258.914469]  _request_firmware+0x19d/0x4b0
[1667258.914476]  firmware_request_nowarn+0x36/0x60
[1667258.914482]  sahara_processing+0x399/0x710 [qaic]
[1667258.914501]  process_one_work+0x181/0x3a0
[1667258.914508]  worker_thread+0x306/0x440
[1667258.914514]  ? _raw_spin_lock_irqsave+0xe/0x20
[1667258.914521]  ? __pfx_worker_thread+0x10/0x10
[1667258.914526]  kthread+0xef/0x120
[1667258.914533]  ? __pfx_kthread+0x10/0x10
[1667258.914540]  ret_from_fork+0x44/0x70
[1667258.914546]  ? __pfx_kthread+0x10/0x10
[1667258.914552]  ret_from_fork_asm+0x1b/0x30
[1667258.914561]  </TASK>
[1667258.914564] Modules linked in: tls nfsv3 rpcsec_gss_krb5 nfsv4 nfs net=
fs snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_midi_event snd_rawmidi sn=
d_seq snd_seq_device snd_timer snd soundcore qrtr_mhi(OE) qrtr(OE) xt_connt=
rack xt_MASQUERADE bridge stp llc xt_set ip_set nft_chain_nat nf_nat nf_con=
ntrack nf_defrag_ipv6 nf_defrag_ipv4 xt_addrtype nft_compat nf_tables xfrm_=
user xfrm_algo openafs(POE-) overlay cfg80211 binfmt_misc nls_iso8859_1 int=
el_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency=
_common isst_if_common skx_edac skx_edac_common nfit x86_pkg_temp_thermal i=
ntel_powerclamp coretemp kvm_intel ipmi_ssif kvm cmdlinepart spi_nor irqbyp=
ass mtd qaic(OE) mei_me rapl intel_cstate i2c_i801 mhi(OE) spi_intel_pci me=
i switchtec(OE) ioatdma spi_intel i2c_smbus intel_pch_thermal dca ipmi_si a=
cpi_power_meter acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad mac_hid sch=
_fq_codel dm_multipath nfsd msr parport_pc auth_rpcgss nfs_acl lockd ppdev =
grace lp parport sunrpc efi_pstore nfnetlink dmi_sysfs
[1667258.914665]  ip_tables x_tables autofs4 btrfs blake2b_generic xor raid=
6_pq libcrc32c dm_mirror dm_region_hash dm_log crct10dif_pclmul crc32_pclmu=
l polyval_clmulni polyval_generic nvme ghash_clmulni_intel sha256_ssse3 bnx=
t_en sha1_ssse3 nvme_core xhci_pci nvme_auth xhci_pci_renesas wmi aesni_int=
el crypto_simd cryptd
[1667258.914741] CR2: ffffb731b3fbcd40
[1667258.914746] ---[ end trace 0000000000000000 ]---

Thanks
- Youssef

