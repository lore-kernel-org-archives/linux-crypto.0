Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBAD19644B
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788004209; cv=pass; b=rhzSIh/LKwYX2YaFgx+5y9FDEBwCWQp/UOIZep7QgEN76qvWEPbXNQqfyYPrGrzfBTFryUjCS8Xc4NqbHg7ZeYK/waJSQivukEAx0NDfZUTwhloImAx391dPaw9NXfVHWn+R8QZBI6r/n8PN05wRH1ZLw7QXgefw4doLZ9xiCDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788004209; c=relaxed/simple;
	bh=XB59oqxnl9vxrJXiFn7gVAo04muqOAUCBSUo2fWNdsg=;
	h=In-Reply-To:References:From:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DwN9YUfLb63JjmDOeLS1901dBqRRQJFRvbjwDZDWgKYUfp1T2aT8UB3vGYgWWZYyrg7sD4jlbhpkzgtvsPJNGYR/+nzB/uI03HofGBOMbG3etNRC9ddG62HKqmI4h2m5zLcR4c5Ofqh1+6lkod3q+6h28qppM6b7K0FnQZtkeK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PtSOMIxX; arc=pass smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PtSOMIxX"
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-396bf83d458so593109a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 04:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788004207; cv=none;
        d=google.com; s=arc-20260327;
        b=UqzTol9OzxCEUpykJLYMZE7TtU/GF/zh20OtmNNFR2Zx9rH3V6NWnDxfsu4v7WMQUw
         6og1BHJLIO7JKHTGY+mJ30LMW5JCqJeN9uKH0J8JRFn0Fvkc/x+lYu4mg6pmeMY57mCO
         hOf3Z0l2xSmZ7lUTnfQsDBHHgTA7ccaBH0bD2kUVew5WOOiebxCy7xpmm7Xv8KYLy8pu
         ESVLhMkPvrrCciqFPdRmwDX0SwZpZYdsEvZKrzEkiTEsBhTC2cpoJKAuBZyfJ5PSswku
         w2MxuBnlq8avjfuQwwDfivfyBlhSVBfom4chHYGIvcTrNiA3ZPQDWsGh6Fg7Q1SAt52J
         uFLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:feedback-id
         :mime-version:from:references:in-reply-to:dkim-signature;
        bh=2V7zWxDDkN+khoCSDL6WUb6TTSsQU+AdkqSv9hV5vbU=;
        fh=6UEBwdAOe1dO7y9PQsXUq4t7s+foI/V856Fg9t/7cAo=;
        b=nj9ffTbHjIXg7EOrLdgOh1h8solpv4QmfOPGHpUYhVFEYFEQC5nAh2nB2bg9JquBtZ
         U4NrbppyvTxmy4pE+n4MjAGdWhdwQdb2K1/VvTI0jDp6u+80Ofo4gf9TZ5SKOG5ijLrZ
         ePhJ/FXTtVOibyJamSC1SwXcvpymtlyrOierE5xDziIz3Ns8pKmiLZcMkIEpmnhu84Wn
         qfPGmV4Ris0m7duhSggsblcQM0y4eaJmd4swxD5aG6d2u1E7w00tlcBvYsYZRjvuqU4U
         NSaWn5aY3nNw9Ll/T3A00HEDQdXNoaQcR8VVEGkiFbZTMRal78l5jR6zFrQEKvL1CM5t
         Lb6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788004207; x=1788609007; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:feedback-id:mime-version:from:references:in-reply-to:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2V7zWxDDkN+khoCSDL6WUb6TTSsQU+AdkqSv9hV5vbU=;
        b=PtSOMIxXaaLKXxudcVpNtcvLi8V16ik2tjYkLbSyjBYfJXfyV4HQiyNTHVXCpL7ngQ
         pHOZW8y/Ci32EFbGwYAn45Fx8sjohYnLK5Xcauz8zyIKtdYLc24T5QdLJqPbisu+VIJb
         9+iknSJTQUlFLGKVaigUrb5PXVBMB1spZdCBBukCxtvlBeD6ZMi1eMiO522IuDbjcHhj
         dordGKnUIdZhdD/SwRlJo+TWFG1l3/dHSPP1+/w9TG73DXsm7A4/9mP/c4lMjXAlY5g/
         4TpBiYVarqPIwi1GN6AbXuF+rxalaTvRVVCn3wLvN3mZAdyAScNnQ2/oryAF0CcRvbAk
         DxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788004207; x=1788609007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:feedback-id:mime-version:from:references:in-reply-to:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2V7zWxDDkN+khoCSDL6WUb6TTSsQU+AdkqSv9hV5vbU=;
        b=VeEKCiStdGoqBTn1SZjzoyugnQAGB21RP/QV9LjoxB8bwL4Fe8wAFHSb7gi8lgTdJl
         sqaM6+Mok9FjvjbKyDx/JbRPIxAVM2t9Pj5q0Bf2NrbDDCxC/Uewj7JK+AEOa2ZKHTy7
         uQmosteNOvf5YgiF6jReI3ssbc3DYdn884jqh1TssIACEoQeZwHHIH59gtefXWI/xFBU
         WDU2u09x8pA3cmanY6bCua3pYXbCoKfod25wqPeyb9BAVeo2xbM59scbeovbGNl5MI6X
         jaL3r0ybJa9Xiu/dTTLUnkaucW/HO2V53Q6BvsFO97pNEPfgUjPUGnLRa82Nmq90glaL
         Q2eA==
X-Forwarded-Encrypted: i=1; AKwUvBz4Gy+Zeo3vImrAuRj03sL/kxhV9zPZLnOZaKyytbu2G4nMmIcUjAB4LnpxidZnX92WMBuXPx5JeJAlRHE=@vger.kernel.org
X-Gm-Message-State: AFuF++n9A7buIFv4gBma00Rj1HKXpjg/8W6VS3wYNTk9ZGnCPuXuTXs6
	phoCMCxd6ZF7eMy/4X79kcK0v9Ce9dGNLKZWrmkAE6ougywwCUKsfNMLHHyP+omqV6GZ4+8q4qu
	T2G+EccYZalll/mG6PHJPF5gJHPb/McY=
X-Gm-Gg: AYBFou297I+kkDkMWF1WkbybL8udwqjUqi/34F9P0rYEeZ6QeEWpZYUoLV08o9DfACs
	iFRTMId5B/z8b1onLFtzl7/aDG6CxOhyJxaZ+b56WyM04x4YjWFWpV2RB1cbqcEDaOupx2b0uGv
	5pj9sfg3wx15KCSdKocySHPVTaEbORyj3PFRDjsjCRGbHx0udCZDL4fbAFgA2aAyktX4qeA2cCy
	5hGCGKWFHoDhKKM/o1TPt9vS51hkoZcx+eejEke7ZwK0KoBzB09D4bcVVmIWxJDILhl6gooELuA
	u8mrMKqcjhfB1MVkUfW9GY3s796JPiI+gtsH+EODLxyp
X-Received: by 2002:a17:90b:5490:b0:398:9be6:f997 with SMTP id
 98e67ed59e1d1-3989be6fabamr8822016a91.22.1788004207359; Sat, 29 Aug 2026
 04:50:07 -0700 (PDT)
Received: from 923746734024 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 29 Aug 2026 04:50:05 -0700
Received: from 923746734024 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 29 Aug 2026 04:50:05 -0700
In-Reply-To: <202608280842.861e5949-lkp@intel.com>
References: <202608280842.861e5949-lkp@intel.com>
From: Quanye Yang <quanyemostima@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Feedback-Id: 213336356:user:proton
X-Pm-Message-Id: 8d3d2ceb8b9608c9c9d01d857cdd8149c2835fc1
X-Pm-Byoe: Pw38uirqT6X9XEzvvf09C3EfIeu8ZGXF2AbJ5Fdhm3gGXIp_YuxTcMUccburTI2jepf8J_UHG8Snr_TTrKwRpA==
Date: Sat, 29 Aug 2026 04:50:05 -0700
X-Gm-Features: AcwNN1X7-N43NwbdvpT-VH5kWVylnqGHXWcCelBlkTW9FoL9KGDR2SlyEm8Am_g
Message-ID: <CABcBDJuRf+TxC+D3FUBA8=DcsLjmU6As77D-VjPRewWvWAizTw@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
To: kernel test robot <yi1.lai@intel.com>
Cc: quanyeyang via B4 Relay <devnull+quanyemostima.gmail.com@kernel.org>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-crypto@vger.kernel.org, Thomas Graf <tgraf@suug.ch>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	NeilBrown <neilb@suse.com>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, 
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sent with Proton Mail secure email.

On Friday, August 28th, 2026 at AM 8:54, kernel test robot
<yi1.lai@intel.com> wrote:

>
> Hello,
>
> kernel test robot noticed a 12.5% regression of stress-ng.shm-sysv.ops_pe=
r_sec on:
>
>
> commit: 62d8460a4e7a3ee028e5134d86169001490e7a60 ("[PATCH] rhashtable: us=
e per-init-site lockdep classes for bucket locks")
> url: https://github.com/intel-lab-lkp/linux/commits/quanyeyang-via-B4-Rel=
ay/rhashtable-use-per-init-site-lockdep-classes-for-bucket-locks/20260815-0=
14140
> patch link: https://lore.kernel.org/all/20260801-fix-rhashtable-bucket-lo=
ckdep-v1-1-15a0f8ae094c@gmail.com/
> patch subject: [PATCH] rhashtable: use per-init-site lockdep classes for =
bucket locks
>
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (S=
apphire Rapids) with 256G memory
> parameters:
>
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: shm-sysv
> 	cpufreq_governor: performance
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202608280842.861e5949-lkp@intel.=
com
>
>
> Details are as below:
> -------------------------------------------------------------------------=
------------------------->
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260828/202608280842.861e5949-lk=
p@intel.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testc=
ase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/l=
kp-spr-r02/shm-sysv/stress-ng/60s
>
> commit:
>   0131b508c0 ("Merge tag 'ntfs-for-7.2-rc6' of git://git.kernel.org/pub/s=
cm/linux/kernel/git/linkinjeon/ntfs")
>   62d8460a4e ("[PATCH] rhashtable: use per-init-site lockdep classes for =
bucket locks")
>
> 0131b508c0e2489e 62d8460a4e7a3ee028e5134d861
> ---------------- ---------------------------
>     192413           +44.1%     277255        stress-ng.shm-sysv.nanosecs=
_per_shmat_call
>     349549           +24.2%     433996        stress-ng.shm-sysv.nanosecs=
_per_shmdt_call
>     174600           +51.9%     265191        stress-ng.shm-sysv.nanosecs=
_per_shmget_call
>     793610           -12.5%     694260        stress-ng.shm-sysv.ops
>      13236           -12.5%      11578        stress-ng.shm-sysv.ops_per_=
sec
>      65737           -10.0%      59167 =C2=B1  4%  stress-ng.time.involun=
tary_context_switches
>   53645785           -12.0%   47213499 =C2=B1  2%  stress-ng.time.minor_p=
age_faults
>       4660           +24.6%       5806        stress-ng.time.percent_of_c=
pu_this_job_got
>       2585           +27.8%       3305        stress-ng.time.system_time
>     214.61           -14.7%     183.11        stress-ng.time.user_time
>   10735595            -7.0%    9986470        stress-ng.time.voluntary_co=
ntext_switches
>
>
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are prov=
ided
> for informational purposes only. Any difference in system hardware or sof=
tware
> design or configuration may affect actual performance.
>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
>
>
Thanks for the report.

This v1 was withdrawn after the subsequent discussion and was never
merged. I do not plan to resend this approach, so no separate fix will
be submitted.

The regression is likely caused by the unconditional bucket_lock_key
pointer changing the size and cacheline layout of struct rhashtable in
a configuration with CONFIG_DEBUG_LOCK_ALLOC disabled.

Thanks for the testing.
