Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795161436;
	b=TbhxBLPxAZ3FaYHDsrsJfDSbWBvuXKJdyttSaVcRRMTBOuBL1JZ5ZVqoVrJpHjYzfx4S
	 WX1UiYYmFrhBsSJHyLMXw3osIWoBI78K3pyh3eOs+3FPcIYkZJI1pbXSH9h8m6Q66dB50
	 Y6of0o41c++B1AvQaZccuhQe/HPFQKrUlS7xqL2WFbYxrr0TlN/M9Malu+isSbZv3omId
	 LRVtILRPNSrSXPO2qjCohCLqf2xUbOgmXfora71trW3tsSjiyDdFp3Cp/1jj9JNdWDdUd
	 8XbGSvmPBDkTdeYkVPhY9q8sL7Nww43GR/Bfbfb7Sow6Aco3+KrPHfZNa57ewIJXZ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795161436;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=cPkzNTeOwaw9FSWnwbEMyoEWrNIpFrCKzuqS6JMRITM=;
	b=Es4XV4p3kEeh+Kr4SsV1oGP+QId7pBNd3VFusxxI5ynUdx/w9qEc9cd5V/VyyXHD0xqG
	 UO7qYKEwyx2kM3shJmTaq3iWYuj1XeWHJgj/aAqIShZdkWTLCUO0VGBZ1LrX5KexMZafV
	 z9IrsxxKzvNrseOnG0rHWSpwTp9K2t3j/sBLUbz1K0a702nKGzt5JOMIFTcz7pqAox9eo
	 J+PdPalB7I+twaGfFw519LmDcyQmQ5EXusECpofUONCCANf9uAf/u88zuM2AtG7xx28Tw
	 TA1oqFAnKrfAiFvdwijPYcTDzYpfuUjBTbLYzMSJLs6fphnIIAuCYxOdVHZi8GGbtVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRXEXv4T;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRXEXv4T;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AD1606A32A;
	Fri, 20 Nov 2026 07:57:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6AD1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRXEXv4T;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pRXEXv4T
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F0ACF1FB70;
	Fri, 20 Nov 2026 07:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795161433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cPkzNTeOwaw9FSWnwbEMyoEWrNIpFrCKzuqS6JMRITM=;
	b=pRXEXv4TMGvHpgSHpb0PdRh5/abAhmVjeaT2JFK6I0Qt0MokNaQvlw+RxfR9S1MLGaGzUn
	NAyOO3t9cZuOagGHBmeqpCXPOMyZLwcEMXMYAWTS15BPrdQ6aWjwv7E44iFLWGw1DDft6R
	BY2IluZo4udwj1B5JmEfXmCvcJ4//Ow=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795161433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cPkzNTeOwaw9FSWnwbEMyoEWrNIpFrCKzuqS6JMRITM=;
	b=pRXEXv4TMGvHpgSHpb0PdRh5/abAhmVjeaT2JFK6I0Qt0MokNaQvlw+RxfR9S1MLGaGzUn
	NAyOO3t9cZuOagGHBmeqpCXPOMyZLwcEMXMYAWTS15BPrdQ6aWjwv7E44iFLWGw1DDft6R
	BY2IluZo4udwj1B5JmEfXmCvcJ4//Ow=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A11CB1348F;
	Fri, 20 Nov 2026 07:57:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9bVdHVb9/2pXGgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 20 Nov 2026 07:57:10 +0000
Message-ID: <3d0e44da-c8cd-4f40-8972-2e41f6a9c363@suse.com>
Date: Fri, 20 Nov 2026 08:57:09 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/12] x86/msr: Drop 32-bit MSR interfaces
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, linux-mtd@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 platform-driver-x86@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 David Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Pu Wen <puwen@hygon.cn>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Ben Horgan <ben.horgan@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <fustini@kernel.org>,
 Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Len Brown <lenb@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 Huang Rui <ray.huang@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Perry Yuan <perry.yuan@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Guenter Roeck <linux@roeck-us.net>,
 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
 Artem Bityutskiy <dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 Xi Pardee <xi.pardee@linux.intel.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>, xen-devel@lists.xenproject.org
References: <20261116150208.1572254-1-jgross@suse.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
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
In-Reply-To: <20261116150208.1572254-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------u7kb0Xp7EU6rqQ9PPLGFYtL4"
X-Spamd-Result: default: False [-8.67 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	NEURAL_SPAM_LONG(3.12)[0.891];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	XM_UA_NO_VERSION(0.01)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~];
	FREEMAIL_CC(0.00)[broadcom.com,kernel.org,redhat.com,gmx.de,lists.infradead.org,selenic.com,gondor.apana.org.au,infradead.org,arm.com,linux.intel.com,google.com,intel.com,linaro.org,microsoft.com,hygon.cn,amd.com,zhaoxin.com,oracle.com,roeck-us.net,gmail.com,arndb.de,linuxfoundation.org,bootlin.com,nod.at,ti.com,lists.xenproject.org];
	HAS_ATTACHMENT(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[94];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLp4bb1nbaxux19m4mhcoiswam)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -8.67
X-Spam-Level: 
X-Spam-Flag: NO

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------u7kb0Xp7EU6rqQ9PPLGFYtL4
Content-Type: multipart/mixed; boundary="------------WVmopiyvEmcrBZ70w9Ul0OzZ";
 protected-headers="v1"; hp="clear"
Message-ID: <3d0e44da-c8cd-4f40-8972-2e41f6a9c363@suse.com>
Date: Fri, 20 Nov 2026 08:57:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/12] x86/msr: Drop 32-bit MSR interfaces
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, linux-mtd@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 platform-driver-x86@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 David Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Pu Wen <puwen@hygon.cn>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Ben Horgan <ben.horgan@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Babu Moger <babu.moger@amd.com>, Drew Fustini <fustini@kernel.org>,
 Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Len Brown <lenb@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 Huang Rui <ray.huang@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Perry Yuan <perry.yuan@amd.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Guenter Roeck <linux@roeck-us.net>,
 Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
 Artem Bityutskiy <dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 Xi Pardee <xi.pardee@linux.intel.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>, xen-devel@lists.xenproject.org
References: <20261116150208.1572254-1-jgross@suse.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
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
In-Reply-To: <20261116150208.1572254-1-jgross@suse.com>

--------------WVmopiyvEmcrBZ70w9Ul0OzZ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW55IGNoYW5jZSB0byBtYWtlIHByb2dyZXNzIG9uIHRoaXMgc2VyaWVzPyBUaGUgb3JpZ2lu
YWwgcGxhbiB3YXMgdG8gaGF2ZQ0KdGhhdCBmaW5pc2hlZCB3aXRoIDcuMy4NCg0KQXMgdGhl
cmUgaGFzIGJhc2ljYWxseSBiZWVuIG5vIGFjdGl2aXR5IHJlbGF0ZWQgdG8gY29tbWl0dGlu
ZyB3aXRoIHRoaXMgc2VyaWVzDQpmb3Igc2V2ZXJhbCBtb250aHMgbm93LCBJIGd1ZXNzIHRo
ZSBpbmRpdmlkdWFsIHBhdGNoZXMgYWxyZWFkeSBhY2tlZCBzaG91bGQgYmUNCnRha2VuIHZp
YSB0aGUgaW5kaXZpZHVhbCB0cmVlcyBub3cgaW5zdGVhZCBvZiB0aGUgb3JpZ2luYWwgcGxh
biB1c2luZyB0aGUgdGlwDQp0cmVlIGZvciB0aGF0Lg0KDQoNCkp1ZXJnZW4NCg0KT24gMTYu
MTEuMjYgMTY6MDEsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IEZvciBhY2Nlc3NpbmcgdGhl
IE1TUiByZWdpc3RlcnMgb24gdGhlIGxvY2FsIENQVSwgdGhlcmUgYXJlIDIgdHlwZXMgb2YN
Cj4gaW50ZXJmYWNlczogdGhlICJtb2Rlcm4iIDY0LWJpdCBvbmVzIChyZG1zcnEoKSBldGMu
KSBhbmQgdGhlIDMyLWJpdA0KPiBvbmVzIChyZG1zcigpIGV0Yy4pIHdoaWNoIGFyZSB1c2lu
ZyB0aGUgdXBwZXIgYW5kIGxvd2VyIDMyLWJpdCBoYWx2ZXMNCj4gb2YgdGhlIDY0LWJpdCB3
aWRlIE1TUiByZWdpc3RlciB2YWx1ZXMuDQo+IA0KPiBUaGUgMzItYml0IGludGVyZmFjZXMg
YXJlIG5vdCBvcHRpbWFsIGZvciAzIHJlYXNvbnM6DQo+IA0KPiAtIFRoZXkgYXJlIGJhc2Vk
IG9uIHByaW1pdGl2ZXMgdXNpbmcgNjQtYml0IHNpemVkIHZhbHVlcyBhbnl3YXkuDQo+IA0K
PiAtIE1vZGVybiB4ODYgQ1BVcyBoYXZlIGFkZGVkIHN1cHBvcnQgZm9yIE1TUiBhY2Nlc3Mg
aW5zdHJ1Y3Rpb25zIHVzaW5nDQo+ICAgIGFuIGltbWVkaWF0ZSB2YWx1ZSBpbnN0ZWFkIG9m
IGEgcmVnaXN0ZXIgZm9yIGFkZHJlc3NpbmcgdGhlIE1TUiwNCj4gICAgd2hpbGUgdGhlIHZh
bHVlIGlzIGluIGEgNjQtYml0IHJlZ2lzdGVyLg0KPiANCj4gLSByZG1zcigpIGlzIGEgbWFj
cm8gc3RvcmluZyB0aGUgdXBwZXIgYW5kIGxvd2VyIDMyLWJpdCBoYWx2ZXMgaW4NCj4gICAg
dmFyaWFibGVzIHNwZWNpZmllZCBhcyBtYWNybyBwYXJhbWV0ZXJzLiBUaGlzIGlzIG9ic2N1
cmluZyB2YXJpYWJsZQ0KPiAgICBhc3NpZ25tZW50IHRocm91Z2ggYSBtYWNyby4gQWRkaXRp
b25hbGx5IHJkbXNycSgpIGlzIG1pbWlja2luZyB0aGlzDQo+ICAgIHBhdHRlcm4gYnkgYmVp
bmcgYSBtYWNybywgdG9vLCB3aXRoIHRoZSB0YXJnZXQgdmFyaWFibGUgc3BlY2lmaWVkIGFz
DQo+ICAgIGEgcGFyYW1ldGVyIGFzIHdlbGwuDQo+IA0KPiBGb3IgdGhvc2UgcmVhc29ucyBk
cm9wIHRoZSAzMi1iaXQgaW50ZXJmYWNlcyBmb3IgYWNjZXNzaW5nIHRoZSB4ODYgTVNSDQo+
IHJlZ2lzdGVycyBjb21wbGV0ZWx5IGFuZCBvbmx5IHVzZSB0aGUgNjQtYml0IHZhcmlhbnRz
Lg0KPiANCj4gVGhpcyBhbGxvd3MgdG8gc3dpdGNoIGFsbCAiaGlnaC1sZXZlbCIgTVNSIGFj
Y2VzcyBtYWNyb3MgdG8gaW5saW5lDQo+IGZ1bmN0aW9ucyBpbiB0aGUgZW5kLg0KPiANCj4g
VGhpcyBzZXJpZXMgd2lsbCBiZSB1c2VkIGFzIHRoZSBiYXNlIGZvciBmdXJ0aGVyIHJlb3Jn
YW5pc2F0aW9uIG9mIHRoZQ0KPiBNU1IgYWNjZXNzIGZ1bmN0aW9ucywgZXNwZWNpYWxseSBm
b3IgY29tcGxldGVseSBpbmxpbmluZyB0aGUgTVNSDQo+IGFjY2VzcyBpbnN0cnVjdGlvbnMg
ZXZlbiB3aXRoIHBhcmF2aXJ0dWFsaXphdGlvbiBiZWluZyBhY3RpdmUuDQo+IA0KPiBCYXNl
ZCBvbiBrZXJuZWwgNy40LXJjMy4NCj4gDQo+IElNSE8gYXQgbGVhc3QgcGF0Y2hlcyAyIGFu
ZCAzIHNob3VsZCBiZSBhcHBsaWVkIHJhdGhlciBzb29uZXIgdGhhbiBsYXRlcg0KPiBpbiBv
cmRlciB0byBhdm9pZCBuZXcgaW5zdGFuY2VzIG9mIHRoZSAzMi1iaXQgdmFyaWFudHMgb2Yg
dGhlICpfc2FmZSgpDQo+IGZ1bmN0aW9ucyBjcmVlcGluZyBpbiBhZ2Fpbi4NCj4gDQo+IENo
YW5nZXMgaW4gVjI6DQo+IC0gZHJvcHBlZCBhbHJlYWR5IGFwcGxpZWQgcGF0Y2hlcw0KPiAt
IGFkZGVkIHBhdGNoIDENCj4gLSByZWJhc2VkDQo+IA0KPiBDaGFuZ2VzIGluIFYzOg0KPiAt
IHNtYWxsIGZpeGVzIGluIHBhdGNoZXMgNCBhbmQgMTMNCj4gLSByZWJhc2VkDQo+IA0KPiBD
aGFuZ2VzIGluIFY0Og0KPiAtIHJlYmFzZWQNCj4gDQo+IENoYW5nZXMgaW4gVjU6DQo+IC0g
cGF0Y2ggOSBvZiBWNCBoYXMgYmVlbiBhcHBsaWVkDQo+IC0gcmViYXNlZA0KPiANCj4gQ2hh
bmdlcyBpbiBWNjoNCj4gLSByZWJhc2VkDQo+IA0KPiBKdWVyZ2VuIEdyb3NzICgxMik6DQo+
ICAgIHg4Ni9jcHU6IEZpeCBjb2Rpbmcgc3R5bGUgdmlvbGF0aW9uDQo+ICAgIHg4Ni9tc3I6
IFJlbW92ZSB3cm1zcl9zYWZlKCkNCj4gICAgeDg2L21zcjogUmVtb3ZlIHJkbXNyX3NhZmUo
KQ0KPiAgICBkcml2ZXJzL2F0YTogU3RvcCB1c2luZyAzMi1iaXQgTVNSIGludGVyZmFjZXMN
Cj4gICAgYWdwL252aWRpYTogU3RvcCB1c2luZyAzMi1iaXQgTVNSIGludGVyZmFjZXMNCj4g
ICAgZmJkZXYvZ2VvZGU6IFN0b3AgdXNpbmcgMzItYml0IE1TUiBpbnRlcmZhY2VzDQo+ICAg
IGh3X3JhbmRvbS92aWEtcm5nOiBTdG9wIHVzaW5nIDMyLWJpdCBNU1IgaW50ZXJmYWNlcw0K
PiAgICBkcml2ZXJzL2dwaW86IFN0b3AgdXNpbmcgMzItYml0IE1TUiBpbnRlcmZhY2VzDQo+
ICAgIHg4Ni9tc3I6IFJlbW92ZSB3cm1zcigpDQo+ICAgIHg4Ni9tc3I6IFJlbW92ZSByZG1z
cigpDQo+ICAgIHRyZWV3aWRlOiBjb252ZXJ0IHJkbXNycSgpIGZyb20gYSBtYWNybyB0byBh
biBpbmxpbmUgZnVuY3Rpb24NCj4gICAgeDg2L21zcjogU2ltcGxpZnkgc29tZSByZG1zcnEo
KSB1c2UgY2FzZXMNCj4gDQo+ICAgYXJjaC94ODYvY29jby9zZXYvY29yZS5jICAgICAgICAg
ICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9ldmVudHMvYW1kL2Jycy5jICAg
ICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9hbWQvY29y
ZS5jICAgICAgICAgICAgICAgICAgICB8ICA4ICstLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9h
bWQvaWJzLmMgICAgICAgICAgICAgICAgICAgICB8IDMwICsrKysrLS0tLS0tDQo+ICAgYXJj
aC94ODYvZXZlbnRzL2FtZC9sYnIuYyAgICAgICAgICAgICAgICAgICAgIHwgMTYgKystLS0t
DQo+ICAgYXJjaC94ODYvZXZlbnRzL2FtZC9wb3dlci5jICAgICAgICAgICAgICAgICAgIHwg
IDggKy0tDQo+ICAgYXJjaC94ODYvZXZlbnRzL2FtZC91bmNvcmUuYyAgICAgICAgICAgICAg
ICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9ldmVudHMvY29yZS5jICAgICAgICAgICAgICAg
ICAgICAgICAgfCAyMCArKysrLS0tLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9pbnRlbC9jb3Jl
LmMgICAgICAgICAgICAgICAgICB8IDE1ICsrLS0tLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9p
bnRlbC9jc3RhdGUuYyAgICAgICAgICAgICAgICB8ICA1ICstDQo+ICAgYXJjaC94ODYvZXZl
bnRzL2ludGVsL2RzLmMgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4
Ni9ldmVudHMvaW50ZWwva25jLmMgICAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+ICAg
YXJjaC94ODYvZXZlbnRzL2ludGVsL2xici5jICAgICAgICAgICAgICAgICAgIHwgMjUgKysr
LS0tLS0tLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9pbnRlbC9wNC5jICAgICAgICAgICAgICAg
ICAgICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9pbnRlbC9wNi5jICAgICAgICAg
ICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYvZXZlbnRzL2ludGVsL3B0LmMgICAg
ICAgICAgICAgICAgICAgIHwgMTIgKystLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvaW50ZWwv
dW5jb3JlLmMgICAgICAgICAgICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMv
aW50ZWwvdW5jb3JlX25obWV4LmMgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2V2
ZW50cy9pbnRlbC91bmNvcmVfc25iLmMgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94
ODYvZXZlbnRzL2ludGVsL3VuY29yZV9zbmJlcC5jICAgICAgICAgIHwgIDYgKy0tDQo+ICAg
YXJjaC94ODYvZXZlbnRzL21zci5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0N
Cj4gICBhcmNoL3g4Ni9ldmVudHMvcGVyZl9ldmVudC5oICAgICAgICAgICAgICAgICAgfCAg
NiArLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvcmFwbC5jICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvemhhb3hpbi9jb3JlLmMgICAgICAg
ICAgICAgICAgfCAxMCArKy0tDQo+ICAgYXJjaC94ODYvaHlwZXJ2L2h2X2FwaWMuYyAgICAg
ICAgICAgICAgICAgICAgIHwgIDkgKystLQ0KPiAgIGFyY2gveDg2L2h5cGVydi9odl9pbml0
LmMgICAgICAgICAgICAgICAgICAgICB8IDI2ICsrKysrLS0tLS0NCj4gICBhcmNoL3g4Ni9o
eXBlcnYvaHZfc3BpbmxvY2suYyAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gv
eDg2L2luY2x1ZGUvYXNtL2FwaWMuaCAgICAgICAgICAgICAgICAgICB8ICA3ICstLQ0KPiAg
IGFyY2gveDg2L2luY2x1ZGUvYXNtL2RlYnVncmVnLmggICAgICAgICAgICAgICB8ICA2ICst
LQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2ZzZ3NiYXNlLmggICAgICAgICAgICAgICB8
ICAyICstDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgICAgICAgICAg
ICAgIHwgMTAgLS0tLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL21zci5oICAgICAgICAg
ICAgICAgICAgICB8IDM5ICsrLS0tLS0tLS0tLS0tLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUv
YXNtL3BhcmF2aXJ0LmggICAgICAgICAgICAgICB8IDI2ICstLS0tLS0tLS0NCj4gICBhcmNo
L3g4Ni9rZXJuZWwvYXBpYy9hcGljLmMgICAgICAgICAgICAgICAgICAgfCAxNCArKystLS0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwvYXBpYy9hcGljX251bWFjaGlwLmMgICAgICAgICAgfCAg
NiArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY2V0LmMgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvYW1kLmMgICAgICAgICAgICAg
ICAgICAgICB8IDE0ICsrKy0tLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvYXBlcmZtcGVy
Zi5jICAgICAgICAgICAgICB8ICA4ICstLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvYnVn
cy5jICAgICAgICAgICAgICAgICAgICB8IDEyICsrLS0tDQo+ICAgYXJjaC94ODYva2VybmVs
L2NwdS9idXNfbG9jay5jICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYv
a2VybmVsL2NwdS9jZW50YXVyLmMgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJj
aC94ODYva2VybmVsL2NwdS9jb21tb24uYyAgICAgICAgICAgICAgICAgIHwgMTIgKystLS0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L2ZlYXRfY3RsLmMgICAgICAgICAgICAgICAgfCAg
NCArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvaHlnb24uYyAgICAgICAgICAgICAgICAg
ICB8ICA0ICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9pbnRlbC5jICAgICAgICAgICAg
ICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9pbnRlbF9lcGIuYyAg
ICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9hbWQu
YyAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvbWNl
L2NvcmUuYyAgICAgICAgICAgICAgICB8ICA4ICstLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9j
cHUvbWNlL2luamVjdC5jICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2Vy
bmVsL2NwdS9tY2UvaW50ZWwuYyAgICAgICAgICAgICAgIHwgMTggKysrLS0tLQ0KPiAgIGFy
Y2gveDg2L2tlcm5lbC9jcHUvbWNlL3A1LmMgICAgICAgICAgICAgICAgICB8ICA4ICstLQ0K
PiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvbWNlL3dpbmNoaXAuYyAgICAgICAgICAgICB8ICAy
ICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9taWNyb2NvZGUvaW50ZWwuYyAgICAgICAg
IHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L21zaHlwZXJ2LmMgICAgICAgICAg
ICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvYW1kLmMgICAg
ICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9jbGVh
bnVwLmMgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9tdHJy
L2dlbmVyaWMuYyAgICAgICAgICAgIHwgMzIgKysrKysrLS0tLS0tDQo+ICAgYXJjaC94ODYv
a2VybmVsL2NwdS9tdHJyL210cnIuYyAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNo
L3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvY29yZS5jICAgICAgICAgICAgfCAgMiArLQ0KPiAg
IGFyY2gveDg2L2tlcm5lbC9jcHUvcmVzY3RybC9tb25pdG9yLmMgICAgICAgICB8ICA0ICst
DQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL3BzZXVkb19sb2NrLmMgICAgIHwg
IDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwvcmR0Z3JvdXAuYyAgICAg
ICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvdG9wb2xvZ3kuYyAgICAgICAg
ICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS90b3BvbG9neV9hbWQu
YyAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3RyYW5zbWV0
YS5jICAgICAgICAgICAgICAgfCAgOCArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Rz
eC5jICAgICAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+ICAgYXJjaC94ODYva2VybmVs
L2NwdS91bXdhaXQuYyAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9r
ZXJuZWwvY3B1L3poYW94aW4uYyAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gv
eDg2L2tlcm5lbC9mcHUvY29yZS5jICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAg
YXJjaC94ODYva2VybmVsL2hwZXQuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwva3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
MiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9tbWNvbmYtZmFtMTBoXzY0LmMgICAgICAgICAg
ICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMgICAgICAgICAgICAg
ICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYva2VybmVsL3Byb2Nlc3NfNjQuYyAgICAg
ICAgICAgICAgICAgIHwgMTQgKysrLS0tDQo+ICAgYXJjaC94ODYva2VybmVsL3Noc3RrLmMg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYva2VybmVsL3Ry
YXBzLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJu
ZWwvdHNjLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2
L2tlcm5lbC90c2NfbXNyLmMgICAgICAgICAgICAgICAgICAgICB8ICA2ICstLQ0KPiAgIGFy
Y2gveDg2L2tlcm5lbC90c2Nfc3luYy5jICAgICAgICAgICAgICAgICAgICB8ICA2ICstLQ0K
PiAgIGFyY2gveDg2L2t2bS9tc3JzLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAy
ICstDQo+ICAgYXJjaC94ODYva3ZtL3N2bS9wbXUuYyAgICAgICAgICAgICAgICAgICAgICAg
IHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9rdm0vdm14L21haW4uYyAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgICAg
ICAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYva3ZtL3ZteC9wbXVfaW50
ZWwuYyAgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYva3ZtL3ZteC9z
Z3guYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYva3Zt
L3ZteC90ZHguYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4
Ni9rdm0vdm14L3ZteC5jICAgICAgICAgICAgICAgICAgICAgICAgfCA0MCArKysrKysrLS0t
LS0tLS0NCj4gICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9saWIvaW5zbi1ldmFsLmMgICAgICAgICAgICAg
ICAgICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9saWIvbXNyLXNtcC5jICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L21tL3BhdC9tZW10eXBlLmMg
ICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYvcGNpL2FtZF9idXMu
YyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYvcGxhdGZv
cm0vb2xwYy9vbHBjLXhvMS1ydGMuYyAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYv
cGxhdGZvcm0vb2xwYy9vbHBjLXhvMS1zY2kuYyAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNo
L3g4Ni9wb3dlci9jcHUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+
ICAgYXJjaC94ODYvcmVhbG1vZGUvaW5pdC5jICAgICAgICAgICAgICAgICAgICAgIHwgIDIg
Ky0NCj4gICBhcmNoL3g4Ni92aXJ0L2h3LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgOCArLS0NCj4gICBhcmNoL3g4Ni92aXJ0L3N2bS9zZXYuYyAgICAgICAgICAgICAgICAg
ICAgICAgfCAyMiArKysrLS0tLQ0KPiAgIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyAg
ICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYveGVuL3N1c3BlbmQuYyAg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBkcml2ZXJzL2FjcGkvcHJvY2Vz
c29yX3BlcmZsaWIuYyAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRyaXZlcnMvYXRhL3Bh
dGFfY3M1NTM1LmMgICAgICAgICAgICAgICAgICAgICB8IDI0ICsrKystLS0tLQ0KPiAgIGRy
aXZlcnMvYXRhL3BhdGFfY3M1NTM2LmMgICAgICAgICAgICAgICAgICAgICB8IDE3ICsrKy0t
LS0NCj4gICBkcml2ZXJzL2NoYXIvYWdwL252aWRpYS1hZ3AuYyAgICAgICAgICAgICAgICAg
fCAzMiArKysrKystLS0tLS0NCj4gICBkcml2ZXJzL2NoYXIvaHdfcmFuZG9tL3ZpYS1ybmcu
YyAgICAgICAgICAgICAgfCAyOSArKysrKy0tLS0tLQ0KPiAgIGRyaXZlcnMvY3B1ZnJlcS9h
Y3BpLWNwdWZyZXEuYyAgICAgICAgICAgICAgICB8ICA4ICstLQ0KPiAgIGRyaXZlcnMvY3B1
ZnJlcS9hbWQtcHN0YXRlLmMgICAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgZHJpdmVy
cy9jcHVmcmVxL2VfcG93ZXJzYXZlci5jICAgICAgICAgICAgICAgIHwgMjAgKysrKy0tLS0N
Cj4gICBkcml2ZXJzL2NwdWZyZXEvaW50ZWxfcHN0YXRlLmMgICAgICAgICAgICAgICAgfCAy
NiArKysrKy0tLS0tDQo+ICAgZHJpdmVycy9jcHVmcmVxL2xvbmdoYXVsLmMgICAgICAgICAg
ICAgICAgICAgIHwgMTIgKystLS0NCj4gICBkcml2ZXJzL2NwdWZyZXEvbG9uZ3J1bi5jICAg
ICAgICAgICAgICAgICAgICAgfCAxNiArKystLS0NCj4gICBkcml2ZXJzL2NwdWZyZXEvcG93
ZXJub3ctazcuYyAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+ICAgZHJpdmVycy9jcHVm
cmVxL3Bvd2Vybm93LWs4LmMgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgZHJpdmVy
cy9jcHVmcmVxL3NwZWVkc3RlcC1jZW50cmluby5jICAgICAgICAgIHwgIDQgKy0NCj4gICBk
cml2ZXJzL2NwdWZyZXEvc3BlZWRzdGVwLWxpYi5jICAgICAgICAgICAgICAgfCAxNCArKyst
LS0NCj4gICBkcml2ZXJzL2VkYWMvYW1kNjRfZWRhYy5jICAgICAgICAgICAgICAgICAgICAg
fCAgNiArLS0NCj4gICBkcml2ZXJzL2VkYWMvaW50ZWwtYmZmLmMgICAgICAgICAgICAgICAg
ICAgICAgfCAgNCArLQ0KPiAgIGRyaXZlcnMvZ3Bpby9ncGlvLWNzNTUzNS5jICAgICAgICAg
ICAgICAgICAgICB8IDEwICsrLS0NCj4gICBkcml2ZXJzL2h2L21zaHZfdnRsX21haW4uYyAg
ICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRyaXZlcnMvaHdtb24vaHdtb24tdmlk
LmMgICAgICAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgZHJpdmVycy9pZGxlL2ludGVs
X2lkbGUuYyAgICAgICAgICAgICAgICAgICAgIHwgMjYgKysrKystLS0tLQ0KPiAgIGRyaXZl
cnMvbWlzYy9jczU1MzUtbWZncHQuYyAgICAgICAgICAgICAgICAgICB8ICA2ICstLQ0KPiAg
IGRyaXZlcnMvbXRkL25hbmQvcmF3L2NzNTUzeF9uYW5kLmMgICAgICAgICAgICB8ICA2ICst
LQ0KPiAgIGRyaXZlcnMvcGxhdGZvcm0veDg2L2ludGVsL2lmcy9sb2FkLmMgICAgICAgICB8
IDEwICsrLS0NCj4gICBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9pbnRlbC9pZnMvcnVudGVzdC5j
ICAgICAgfCAgOCArLS0NCj4gICBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9pbnRlbC9wbWMvY25w
LmMgICAgICAgICAgfCAgMiArLQ0KPiAgIC4uLi9pbnRlbC9zcGVlZF9zZWxlY3RfaWYvaXNz
dF9pZl9tYm94X21zci5jICB8ICA2ICstLQ0KPiAgIC4uLi9pbnRlbC9zcGVlZF9zZWxlY3Rf
aWYvaXNzdF90cG1pX2NvcmUuYyAgICB8ICAyICstDQo+ICAgZHJpdmVycy9wbGF0Zm9ybS94
ODYvaW50ZWxfaXBzLmMgICAgICAgICAgICAgIHwgMjAgKysrKy0tLS0NCj4gICBkcml2ZXJz
L3Bvd2VyY2FwL2ludGVsX3JhcGxfbXNyLmMgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRy
aXZlcnMvdGhlcm1hbC9pbnRlbC9pbnRlbF9oZmkuYyAgICAgICAgICAgICB8ICA4ICstLQ0K
PiAgIGRyaXZlcnMvdGhlcm1hbC9pbnRlbC90aGVybV90aHJvdC5jICAgICAgICAgICB8IDIy
ICsrKystLS0tDQo+ICAgZHJpdmVycy90aGVybWFsL2ludGVsL3g4Nl9wa2dfdGVtcF90aGVy
bWFsLmMgIHwgIDYgKy0tDQo+ICAgZHJpdmVycy92aWRlby9mYmRldi9nZW9kZS9kaXNwbGF5
X2d4LmMgICAgICAgIHwgIDggKy0tDQo+ICAgZHJpdmVycy92aWRlby9mYmRldi9nZW9kZS9n
eGZiX2NvcmUuYyAgICAgICAgIHwgIDIgKy0NCj4gICBkcml2ZXJzL3ZpZGVvL2ZiZGV2L2dl
b2RlL2x4ZmJfb3BzLmMgICAgICAgICAgfCA1MCArKysrKysrKystLS0tLS0tLS0tDQo+ICAg
ZHJpdmVycy92aWRlby9mYmRldi9nZW9kZS9zdXNwZW5kX2d4LmMgICAgICAgIHwgMjQgKysr
KystLS0tDQo+ICAgZHJpdmVycy92aWRlby9mYmRldi9nZW9kZS92aWRlb19neC5jICAgICAg
ICAgIHwgIDggKy0tDQo+ICAgaW5jbHVkZS9saW51eC9jczU1MzUuaCAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMTAgKystLQ0KPiAgIDE0MCBmaWxlcyBjaGFuZ2VkLCA1NzIgaW5zZXJ0
aW9ucygrKSwgNjkwIGRlbGV0aW9ucygtKQ0KPiANCg0K

--------------WVmopiyvEmcrBZ70w9Ul0OzZ--

--------------u7kb0Xp7EU6rqQ9PPLGFYtL4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmr//VYFAwAAAAAACgkQsN6d1ii/Ey+B
zwf/fro60QewnznBiKZwbsirR/+lQ/3cYLPhMFnk81SdfvytEFmHf5edgR2nPXyNzkZC1ALiOwId
k6VNDC1HEULRlenJ4+J39FsGplBa8c9lcrizDpixhksOk1DpYW2Ft/xKPW6UXozg2FOyHrfxX/b8
d40kAxkAunjwmR5mEZNyhwOc6WmbAs/9yMLoGgRRfWO+rRHxzl6flGxIKR9aCR1q87bQjCadRyr2
aGYi265ADX6KSNHo84rk79t4R0RC+tvLH97BWLfqTPrQUt2jhsBmOFuGz3elnLBqKN224LWgbCx+
nE5W4e14ksxowsFwsjzyzTQxzbA0wrPMJPjYVVkFSg==
=hU6A
-----END PGP SIGNATURE-----

--------------u7kb0Xp7EU6rqQ9PPLGFYtL4--
