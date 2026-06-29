Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA053BED7F
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 07:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782716501; cv=none; b=hqExf58NiG/p29YTCsMeDg/CMtTe0qyzbbBnJAjM9RieVpxlOlyBGYkcmIchdebjpYW0KC4LGUn3b2PM2pZNqAv7oHqHnQ3p4Jf7InwLejJNj5AgnmYh+hbx2tjZHj0bK4FzCe99YF1cuxxtq+/GtIsx+TuARZ8a0bDXL0I6RZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782716501; c=relaxed/simple;
	bh=WsztnGJuvJ11fz8SxjeHaBbToOxHKZqr51yhgWwvivM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHwqaY5vrOnq6XsJmeYCRsmYd4a/2qFq8wbMgNoZqF6FBk2I2EryAaBege/ZYHeiPDLsbza4aVxx13apRcp5IWt3ckmYRVroB8WxJKmvdZmxO0+GVoaw9vGnDOqQl5WrbQlF7NPQaL6be7P6Qkn091xZm1tQDcuIp0CEjPN9rKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IbRX/t5O; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IbRX/t5O"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso38245095e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 00:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782716499; x=1783321299; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WsztnGJuvJ11fz8SxjeHaBbToOxHKZqr51yhgWwvivM=;
        b=IbRX/t5OJOA9d5Tror6bdVhj7jy1/ijTbirH1RvTeltFcjwU+8rjGbqvS2p5R7MLjn
         tuyPQT6xgbDL/5iRq5L3M5cxiGZBgeZIQaK2cBkuEPEQi4F0l7cMk5q3PIdFjfw6LxwE
         AechQk20hBq2txFUHDg4KmtKdCQaQHY3vF0NLf8X8RUsXw6K7ii2qe40E5Q+XtImGsDm
         VLitfznchfC2gaZpAtgXPV/9CYZYg4vWT+DYaG9+uHKbJQIMvgN1rdHr0FfMAdkBRq1M
         z6SumJuXxyraThKKzE3rJEvbZClBxqi3QrMdw7rMpzPW7ReQmYcveWD2HlsjW4DfO6bc
         0iyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782716499; x=1783321299;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsztnGJuvJ11fz8SxjeHaBbToOxHKZqr51yhgWwvivM=;
        b=MBo+U3Ill0oRmUDjmW5mW0DLBwQ3qbmZls+DcD2O1/HoC/bPxLmNFHrURWF8mBn00k
         ls3l2inyxaLZhqU+JVQ1sGsrvJ/gdtOzDUzCRYLDdLdP46Nfn4fbexAPBuTu85aPmh1T
         04ri+Jl4mI8AMznnFcH73+lgngv2VfRMAj5sB0IKdnxnIu8eraRp8Ycl8mJgfbLoCTS3
         Mlhu/813Yqav93rRCbODENzg33mI9hrEOzJisbQvVMwjEVUPfQCwXAkmiha7DlcXE/xy
         r7Ntfnuw2pNFAxgtk963XLyb6QI0oWaLlIdpfy97b+OktXG/V/4xOWL7yZeMXkRQsk0F
         jAXw==
X-Forwarded-Encrypted: i=1; AFNElJ+sXawpaq5SY4aPKkvNMyUGSP1diY/VgTTBoEU/l4uvungFBB++7UHjhKDCtOYgjEoWmvGg20WiK+L3dXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpbPw63FS1izFMjBaMsa8HEkxfHOldNaoxKwp4vgxFFKLI46UA
	9QdOVMOokh6LWXGfupeV6nRDwMkRzK0M5QieWG1cg+nxJ9DrQuBbGt7b7Mw4T4yxhgk=
X-Gm-Gg: AfdE7cm5qqPPPCm7sp1F+uthdgerenxMn3NbfmLgfBk6kNGrdXqCkSWyAmKIUx9on5h
	Y3kKj570m+0HBs6unnuSXUTT68yRokDTB8d1xoC6ZB1w3VkMRi2eyFetui4z/8WO04AkqrCMlqa
	sYsRRNMCZTcSzi4ceP0ts2MT0ZZDs+APgolY76BMRtoHokTzulkHC/YhN06lIEzzj5Dw6cqfwNC
	MUXjGqyVyduWjF6IPuc3onLgilz1Za25R/7P4Hq2mRX28QJR17o1oYjQA/U2EA7Uq89i9AubIIE
	9DriIKaLBpZPJcNEFJ327z2ZgjJJXIHFUV12RHThmaK53wTGGkw4eYpQiHtlcJKBhKq3UeM3iMF
	fvYo5yP/kyVhxcgt6XhBN3BSpioB+fouG78z0rrzUhX/yYnXiDuoSJLfPVxSQn01qa170M1Q0aJ
	HWpt+biu4C19PWel4Ap1iBexMm+ryIOa09q916BAhNnH0f+oepm7Fn/LYjhfORvA3v8+j2wLHCB
	Pwh0k4FEoa8ALliFz+RWd+aBto1
X-Received: by 2002:a05:600c:138e:b0:490:d38c:7836 with SMTP id 5b1f17b1804b1-49266832313mr240270835e9.3.1782716498009;
        Mon, 29 Jun 2026 00:01:38 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b124ceeesm37235175e9.11.2026.06.29.00.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 00:01:37 -0700 (PDT)
Message-ID: <c1608c48-13c2-4290-826b-28b5ca51eaf7@suse.com>
Date: Mon, 29 Jun 2026 09:01:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/32] x86/msr: Drop 32-bit MSR interfaces
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, x86@kernel.org,
 linux-acpi@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org, virtualization@lists.linux.dev,
 linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fbdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
 linux-hyperv@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-mtd@lists.infradead.org,
 platform-driver-x86@vger.kernel.org
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 "lukasz.luba@arm.com" <lukasz.luba@arm.com>, Jason Baron
 <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
 Tony Luck <tony.luck@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Pu Wen <puwen@hygon.cn>,
 Bjorn Helgaas <bhelgaas@google.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Dave Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Huang Rui <ray.huang@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Perry Yuan <perry.yuan@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 "srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
 Artem Bityutskiy <dedekind1@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 David E Box <david.e.box@intel.com>, xen-devel@lists.xenproject.org
References: <20260629060526.3638272-1-jgross@suse.com>
 <d7c1db52-529a-43cc-ac7d-38b52627e8bc@app.fastmail.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <d7c1db52-529a-43cc-ac7d-38b52627e8bc@app.fastmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------o4KOfe8V3soJd2q9AonYj03N"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------o4KOfe8V3soJd2q9AonYj03N
Content-Type: multipart/mixed; boundary="------------JoYEqla26Z38LihNsoOMoTiX";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, x86@kernel.org,
 linux-acpi@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org, virtualization@lists.linux.dev,
 linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fbdev@vger.kernel.org, linux-crypto@vger.kernel.org,
 "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
 linux-hyperv@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-mtd@lists.infradead.org,
 platform-driver-x86@vger.kernel.org
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 "lukasz.luba@arm.com" <lukasz.luba@arm.com>, Jason Baron
 <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
 Tony Luck <tony.luck@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Pu Wen <puwen@hygon.cn>,
 Bjorn Helgaas <bhelgaas@google.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Dave Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Huang Rui <ray.huang@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Perry Yuan <perry.yuan@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 "srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
 Artem Bityutskiy <dedekind1@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 David E Box <david.e.box@intel.com>, xen-devel@lists.xenproject.org
Message-ID: <c1608c48-13c2-4290-826b-28b5ca51eaf7@suse.com>
Subject: Re: [PATCH 00/32] x86/msr: Drop 32-bit MSR interfaces
References: <20260629060526.3638272-1-jgross@suse.com>
 <d7c1db52-529a-43cc-ac7d-38b52627e8bc@app.fastmail.com>
In-Reply-To: <d7c1db52-529a-43cc-ac7d-38b52627e8bc@app.fastmail.com>

--------------JoYEqla26Z38LihNsoOMoTiX
Content-Type: multipart/mixed; boundary="------------fBgEihXXOOIkwk7ugHYodmnI"

--------------fBgEihXXOOIkwk7ugHYodmnI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjkuMDYuMjYgMDg6NTIsIEFybmQgQmVyZ21hbm4gd3JvdGU6DQo+IE9uIE1vbiwgSnVu
IDI5LCAyMDI2LCBhdCAwODowNCwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+IEZvciBhY2Nl
c3NpbmcgdGhlIE1TUiByZWdpc3RlcnMgb24gdGhlIGxvY2FsIENQVSwgdGhlcmUgYXJlIDIg
dHlwZXMgb2YNCj4+IGludGVyZmFjZXM6IHRoZSAibW9kZXJuIiA2NC1iaXQgb25lcyAocmRt
c3JxKCkgZXRjLikgYW5kIHRoZSAzMi1iaXQNCj4+IG9uZXMgKHJkbXNyKCkgZXRjLikgd2hp
Y2ggYXJlIHVzaW5nIHRoZSB1cHBlciBhbmQgbG93ZXIgMzItYml0IGhhbHZlcw0KPj4gb2Yg
dGhlIDY0LWJpdCB3aWRlIE1TUiByZWdpc3RlciB2YWx1ZXMuDQo+Pg0KPj4gVGhlIDMyLWJp
dCBpbnRlcmZhY2VzIGFyZSBub3Qgb3B0aW1hbCBmb3IgMyByZWFzb25zOg0KPj4NCj4+IC0g
VGhleSBhcmUgYmFzZWQgb24gcHJpbWl0aXZlcyB1c2luZyA2NC1iaXQgc2l6ZWQgdmFsdWVz
IGFueXdheS4NCj4+DQo+PiAtIE1vZGVybiB4ODYgQ1BVcyBoYXZlIGFkZGVkIHN1cHBvcnQg
Zm9yIE1TUiBhY2Nlc3MgaW5zdHJ1Y3Rpb25zIHVzaW5nDQo+PiAgICBhbiBpbW1lZGlhdGUg
dmFsdWUgaW5zdGVhZCBvZiBhIHJlZ2lzdGVyIGZvciBhZGRyZXNzaW5nIHRoZSBNU1IsDQo+
PiAgICB3aGlsZSB0aGUgdmFsdWUgaXMgaW4gYSA2NC1iaXQgcmVnaXN0ZXIuDQo+Pg0KPj4g
LSByZG1zcigpIGlzIGEgbWFjcm8gc3RvcmluZyB0aGUgdXBwZXIgYW5kIGxvd2VyIDMyLWJp
dCBoYWx2ZXMgaW4NCj4+ICAgIHZhcmlhYmxlcyBzcGVjaWZpZWQgYXMgbWFjcm8gcGFyYW1l
dGVycy4gVGhpcyBpcyBvYnNjdXJpbmcgdmFyaWFibGUNCj4+ICAgIGFzc2lnbm1lbnQgdGhy
b3VnaCBhIG1hY3JvLiBBZGRpdGlvbmFsbHkgcmRtc3JxKCkgaXMgbWltaWNraW5nIHRoaXMN
Cj4+ICAgIHBhdHRlcm4gYnkgYmVpbmcgYSBtYWNybywgdG9vLCB3aXRoIHRoZSB0YXJnZXQg
dmFyaWFibGUgc3BlY2lmaWVkIGFzDQo+PiAgICBhIHBhcmFtZXRlciBhcyB3ZWxsLg0KPj4N
Cj4+IEZvciB0aG9zZSByZWFzb25zIGRyb3AgdGhlIDMyLWJpdCBpbnRlcmZhY2VzIGZvciBh
Y2Nlc3NpbmcgdGhlIHg4NiBNU1INCj4+IHJlZ2lzdGVycyBjb21wbGV0ZWx5IGFuZCBvbmx5
IHVzZSB0aGUgNjQtYml0IHZhcmlhbnRzLg0KPiANCj4gSGkgSsO8cmdlbiwNCj4gDQo+IEkg
YXNzdW1lIHRoaXMgaXMgZmluZSwgYnV0IHNpbmNlIHlvdSBkb24ndCBtZW50aW9uIGl0IGV4
cGxpY2l0bHkgaGVyZSwNCj4gcGxlYXNlIGNsYXJpZnkgd2hhdCB0aGlzIG1lYW5zIGZvciAz
Mi1iaXQgQ1BVcyB3aXRob3V0IHRoZSByZG1zcnENCj4gaW5zdHJ1Y3Rpb24uIFRob3NlIHdp
bGwgY29udGludWUgdXNpbmcgdGhlIHNhbWUgaW5zdHJ1Y3Rpb25zIGFzIGJlZm9yZQ0KPiBh
bmQganVzdCBjaGFuZ2UgdGhlIGNhbGxpbmcgY29udmVudGlvbnMsIHJpZ2h0Pw0KDQpZZXMu
IEkgdGhvdWdodCB0aGlzIHdvdWxkIGJlIGNsZWFyIGZyb20gdGhlIGZvbGxvd2luZzoNCg0K
ICAgLSBUaGV5IGFyZSBiYXNlZCBvbiBwcmltaXRpdmVzIHVzaW5nIDY0LWJpdCBzaXplZCB2
YWx1ZXMgYW55d2F5Lg0KDQo+IA0KPj4gTm90ZSB0aGF0IG1vc3QgcGF0Y2hlcyBvZiB0aGlz
IHNlcmllcyBhcmUgaW5kZXBlbmRlbnQgZnJvbSBlYWNoIG90aGVyLg0KPj4gT25seSB0aGUg
cGF0Y2hlcyByZW1vdmluZyBhIHNwZWNpZmljIGludGVyZmFjZSAocGF0Y2hlcyA3LCAxNSwg
MjYgYW5kDQo+PiAzMCkgYW5kIHRoZSBsYXN0IHR3byBwYXRjaGVzIG9mIHRoZSBzZXJpZXMg
ZGVwZW5kIG9uIGFsbCBwcmV2aW91cw0KPj4gcGF0Y2hlcy4NCj4gDQo+IEl0IGxvb2tzIGxp
a2UgeW91IGFyZSB0b3VjaGluZyBtb3N0IGZpbGVzIHR3aWNlIG9yIG1vcmUgaGVyZSwgdG8N
Cj4gZmlyc3QgY29udmVydCBmcm9tIHJkbXNyIHRvIHJkbXNycSBhbmQgdGhlbiB0byBjaGFu
Z2UgdGhlDQo+IHR3by1hcmd1bWVudCByZG1zcnEoKSBtYWNybyB0byBhIHNpbmdsZS1hcmd1
bWVudCBpbmxpbmUuIElmIHlvdQ0KPiBpbnRyb2R1Y2UgdGhlIGlubGluZSB2ZXJzaW9uIG9m
IHJkbXNycSgpIGZpcnN0LCB5b3Ugc2hvdWxkIGJlDQo+IGFibGUgdG8gc2tpcCB0aGUgc2Vj
b25kIHN0ZXAgKHBhdGNoIDMxKSBhcyB0aGV5IGNvdWxkIGJlIGFibGUNCj4gdG8gY29leGlz
dC4NCg0KSSd2ZSBkaXNjdXNzZWQgaG93IHRvIHN0cnVjdHVyZSB0aGUgc2VyaWVzIHdpdGgg
SW5nbyBNb2xuYXIgYmVmb3JlIFsxXS4gVGhlDQpjdXJyZW50IGFwcHJvYWNoIHdhcyBoaXMg
cHJlZmVyZW5jZS4NCg0KDQpKdWVyZ2VuDQoNClsxXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGttbC9mOGQwMmM3OC00NjgxLTQwNDMtYTVmYS05MjFmYTc5MGIxYjRAc3VzZS5jb20v
DQo=
--------------fBgEihXXOOIkwk7ugHYodmnI
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------fBgEihXXOOIkwk7ugHYodmnI--

--------------JoYEqla26Z38LihNsoOMoTiX--

--------------o4KOfe8V3soJd2q9AonYj03N
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmpCGE4FAwAAAAAACgkQsN6d1ii/Ey/w
Ngf/UvpAlY37jaRXT4Gj/Y5F0ZXdp1ZD2E1apa1aY7dceskTJxh6t6dc4UlMxlSkdQuy7J8+SnQA
z6DChoOnF2eFbku2qFsuycbu8XWJ4j9zWGuHe0BcSjvbbSwGDjD+ZXZ2TBjC8YLlRmxihOW7ZQeF
Lmh1U4jclRtlqR9YSq6BTOkev78sF7Hfpuye36htzf2g0AIsLgY5RceceASRLnfUptj5FOodVIp1
APSbWUMLrRockjd/KqHA4pbUfR7nhmIv7YKmA5HBiibHb1sYvm1qU1Z1ANroFmvCS88IpklxQYcT
S6h8+CM6IjjDB+a9m/DLfALjGqC4pRDPSQiZTXhG+w==
=s0zj
-----END PGP SIGNATURE-----

--------------o4KOfe8V3soJd2q9AonYj03N--
