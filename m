Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B174AEBF5;
	Mon, 21 Sep 2026 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790004238; cv=none; b=nerQUl/dkQpgKIZQAAZLdRifBiFuLhH5AC3NCTqeDMOAl5V46DAAhENUjDxLgpSahYqWcp+bvPZGwOtfceSovYT1LtRFZDDG0eJHU3ipyxsq8aTIbgxSRTMQ+e0yJU0nWFDNowDvIMHIRz+VV1URISzd2ucZ+CMAX0Rm1DsmHBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790004238; c=relaxed/simple;
	bh=/VkC67msFQZzDCHeLIME8y32FTfMzKWh+3d2Bu15lIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G6f/vDp6xMm1fQEgLYiMrpo5ZjiNLr0RwY0PfMmkkextADUgyE42YhlqTlzOK3VK53ihgqYBfJhehwKFuWOtPuS3yacAunrKoKE4tkRVMAQwFfXwN+eFa7Hq60wTkYvSOb/OgDui35ZLwghlite9r3vlSHviouuGoVVrjXh9MpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eGWxoMWW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MG0RJ5NW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eGWxoMWW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MG0RJ5NW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 89916219B3;
	Mon, 21 Sep 2026 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790004228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/VkC67msFQZzDCHeLIME8y32FTfMzKWh+3d2Bu15lIs=;
	b=eGWxoMWWjb3KQyPwLxRQ56DQpkuu47zbkNyrbyWWCoS86qr+Oo5WwgNwIoR0fSB2C5Id4S
	Rwc7fbuSbUSuE0sy2ZvFIkDOceABsXXvFuIGhXCczV73CZDRRcwQcWDgbhGir3pWjGnFjO
	Mp3WgCJJlNn7gTxAM0lkAwsHcuGvqdk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MG0RJ5NW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790004224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/VkC67msFQZzDCHeLIME8y32FTfMzKWh+3d2Bu15lIs=;
	b=MG0RJ5NWcjT0bvQlmoPyqzoMfwSY52OvREe84/xPqggmc9Jh3O2yB0v8OIg0cMAMHs7eJ7
	S9R9zcd/RpnTqTQgUSOAEWXIk56GZ40SwbQQWFMzQesRCvvJyzU/8CcCF4qABST5JrxOGQ
	cqwdlWChCyZ+ZgdWGE0m3wWY9ArV0WQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33B9E13793;
	Mon, 21 Sep 2026 15:23:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKI5A/5LsWrMfAAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 21 Sep 2026 15:23:42 +0000
Message-ID: <6df2617a-5bee-4bac-822d-a4ca09c47e76@suse.com>
Date: Mon, 21 Sep 2026 17:23:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/13] x86/msr: Drop 32-bit MSR interfaces
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mtd@lists.infradead.org, platform-driver-x86@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 David Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Pu Wen <puwen@hygon.cn>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
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
 Artem Bityutskiy <dedekind1@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 Xi Pardee <xi.pardee@linux.intel.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>, xen-devel@lists.xenproject.org
References: <20260911074530.3140830-1-jgross@suse.com>
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
In-Reply-To: <20260911074530.3140830-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------axxK79NgUHTDoQRwnbgWpSYy"
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 89916219B3
X-Spamd-Result: default: False [-3.91 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_CC(0.00)[kernel.org,alien8.de,linux.intel.com,zytor.com,broadcom.com,redhat.com,gmx.de,lists.infradead.org,selenic.com,gondor.apana.org.au,arndb.de,linuxfoundation.org,infradead.org,arm.com,google.com,intel.com,linaro.org,microsoft.com,hygon.cn,amd.com,zhaoxin.com,oracle.com,roeck-us.net,gmail.com,bootlin.com,nod.at,ti.com,lists.xenproject.org];
	R_RATELIMIT(0.00)[to_ip_from(RLd6eq7w9gpcedu6aekum1umqh)];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	RCPT_COUNT_GT_50(0.00)[94];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -3.91

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------axxK79NgUHTDoQRwnbgWpSYy
Content-Type: multipart/mixed; boundary="------------T4ZJp6Lhzy2IBIrjLpBsTTw0";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux.dev, linux-ide@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mtd@lists.infradead.org, platform-driver-x86@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 David Airlie <airlied@redhat.com>, Helge Deller <deller@gmx.de>,
 linux-geode@lists.infradead.org, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Pu Wen <puwen@hygon.cn>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
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
 Artem Bityutskiy <dedekind1@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
 Xi Pardee <xi.pardee@linux.intel.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>, xen-devel@lists.xenproject.org
Message-ID: <6df2617a-5bee-4bac-822d-a4ca09c47e76@suse.com>
Subject: Re: [PATCH v3 00/13] x86/msr: Drop 32-bit MSR interfaces
References: <20260911074530.3140830-1-jgross@suse.com>
In-Reply-To: <20260911074530.3140830-1-jgross@suse.com>

--------------T4ZJp6Lhzy2IBIrjLpBsTTw0
Content-Type: multipart/mixed; boundary="------------dtnWD0jmGt0coRzSWi6oU7rk"

--------------dtnWD0jmGt0coRzSWi6oU7rk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SW5nbywNCg0KT24gMTEuMDkuMjYgMDk6NDUsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IEZv
ciBhY2Nlc3NpbmcgdGhlIE1TUiByZWdpc3RlcnMgb24gdGhlIGxvY2FsIENQVSwgdGhlcmUg
YXJlIDIgdHlwZXMgb2YNCj4gaW50ZXJmYWNlczogdGhlICJtb2Rlcm4iIDY0LWJpdCBvbmVz
IChyZG1zcnEoKSBldGMuKSBhbmQgdGhlIDMyLWJpdA0KPiBvbmVzIChyZG1zcigpIGV0Yy4p
IHdoaWNoIGFyZSB1c2luZyB0aGUgdXBwZXIgYW5kIGxvd2VyIDMyLWJpdCBoYWx2ZXMNCj4g
b2YgdGhlIDY0LWJpdCB3aWRlIE1TUiByZWdpc3RlciB2YWx1ZXMuDQo+IA0KPiBUaGUgMzIt
Yml0IGludGVyZmFjZXMgYXJlIG5vdCBvcHRpbWFsIGZvciAzIHJlYXNvbnM6DQo+IA0KPiAt
IFRoZXkgYXJlIGJhc2VkIG9uIHByaW1pdGl2ZXMgdXNpbmcgNjQtYml0IHNpemVkIHZhbHVl
cyBhbnl3YXkuDQo+IA0KPiAtIE1vZGVybiB4ODYgQ1BVcyBoYXZlIGFkZGVkIHN1cHBvcnQg
Zm9yIE1TUiBhY2Nlc3MgaW5zdHJ1Y3Rpb25zIHVzaW5nDQo+ICAgIGFuIGltbWVkaWF0ZSB2
YWx1ZSBpbnN0ZWFkIG9mIGEgcmVnaXN0ZXIgZm9yIGFkZHJlc3NpbmcgdGhlIE1TUiwNCj4g
ICAgd2hpbGUgdGhlIHZhbHVlIGlzIGluIGEgNjQtYml0IHJlZ2lzdGVyLg0KPiANCj4gLSBy
ZG1zcigpIGlzIGEgbWFjcm8gc3RvcmluZyB0aGUgdXBwZXIgYW5kIGxvd2VyIDMyLWJpdCBo
YWx2ZXMgaW4NCj4gICAgdmFyaWFibGVzIHNwZWNpZmllZCBhcyBtYWNybyBwYXJhbWV0ZXJz
LiBUaGlzIGlzIG9ic2N1cmluZyB2YXJpYWJsZQ0KPiAgICBhc3NpZ25tZW50IHRocm91Z2gg
YSBtYWNyby4gQWRkaXRpb25hbGx5IHJkbXNycSgpIGlzIG1pbWlja2luZyB0aGlzDQo+ICAg
IHBhdHRlcm4gYnkgYmVpbmcgYSBtYWNybywgdG9vLCB3aXRoIHRoZSB0YXJnZXQgdmFyaWFi
bGUgc3BlY2lmaWVkIGFzDQo+ICAgIGEgcGFyYW1ldGVyIGFzIHdlbGwuDQo+IA0KPiBGb3Ig
dGhvc2UgcmVhc29ucyBkcm9wIHRoZSAzMi1iaXQgaW50ZXJmYWNlcyBmb3IgYWNjZXNzaW5n
IHRoZSB4ODYgTVNSDQo+IHJlZ2lzdGVycyBjb21wbGV0ZWx5IGFuZCBvbmx5IHVzZSB0aGUg
NjQtYml0IHZhcmlhbnRzLg0KPiANCj4gVGhpcyBhbGxvd3MgdG8gc3dpdGNoIGFsbCAiaGln
aC1sZXZlbCIgTVNSIGFjY2VzcyBtYWNyb3MgdG8gaW5saW5lDQo+IGZ1bmN0aW9ucyBpbiB0
aGUgZW5kLg0KPiANCj4gVGhpcyBzZXJpZXMgd2lsbCBiZSB1c2VkIGFzIHRoZSBiYXNlIGZv
ciBmdXJ0aGVyIHJlb3JnYW5pc2F0aW9uIG9mIHRoZQ0KPiBNU1IgYWNjZXNzIGZ1bmN0aW9u
cywgZXNwZWNpYWxseSBmb3IgY29tcGxldGVseSBpbmxpbmluZyB0aGUgTVNSDQo+IGFjY2Vz
cyBpbnN0cnVjdGlvbnMgZXZlbiB3aXRoIHBhcmF2aXJ0dWFsaXphdGlvbiBiZWluZyBhY3Rp
dmUuDQo+IA0KPiBCYXNlZCBvbiBrZXJuZWwgNy4zIGFzIG9mIDIwMjYtMDktMTEuDQo+IA0K
PiBDaGFuZ2VzIGluIFYyOg0KPiAtIGRyb3BwZWQgYWxyZWFkeSBhcHBsaWVkIHBhdGNoZXMN
Cj4gLSBhZGRlZCBwYXRjaCAxDQo+IC0gcmViYXNlZA0KPiANCj4gQ2hhbmdlcyBpbiBWMzoN
Cj4gLSBzbWFsbCBmaXhlcyBpbiBwYXRjaGVzIDQgYW5kIDEzDQo+IC0gcmViYXNlZA0KPiAN
Cj4gSnVlcmdlbiBHcm9zcyAoMTMpOg0KPiAgICB4ODYvY3B1OiBGaXggY29kaW5nIHN0eWxl
IHZpb2xhdGlvbg0KPiAgICB4ODYvbXNyOiBSZW1vdmUgd3Jtc3Jfc2FmZSgpDQo+ICAgIHg4
Ni9tc3I6IFJlbW92ZSByZG1zcl9zYWZlKCkNCj4gICAgZHJpdmVycy9hdGE6IFN0b3AgdXNp
bmcgMzItYml0IE1TUiBpbnRlcmZhY2VzDQo+ICAgIGFncC9udmlkaWE6IFN0b3AgdXNpbmcg
MzItYml0IE1TUiBpbnRlcmZhY2VzDQo+ICAgIGZiZGV2L2dlb2RlOiBTdG9wIHVzaW5nIDMy
LWJpdCBNU1IgaW50ZXJmYWNlcw0KPiAgICBod19yYW5kb20vdmlhLXJuZzogU3RvcCB1c2lu
ZyAzMi1iaXQgTVNSIGludGVyZmFjZXMNCj4gICAgZHJpdmVycy9ncGlvOiBTdG9wIHVzaW5n
IDMyLWJpdCBNU1IgaW50ZXJmYWNlcw0KPiAgICBkcml2ZXJzL21pc2M6IFN0b3AgdXNpbmcg
MzItYml0IE1TUiBpbnRlcmZhY2VzDQo+ICAgIHg4Ni9tc3I6IFJlbW92ZSB3cm1zcigpDQo+
ICAgIHg4Ni9tc3I6IFJlbW92ZSByZG1zcigpDQo+ICAgIHRyZWV3aWRlOiBjb252ZXJ0IHJk
bXNycSgpIGZyb20gYSBtYWNybyB0byBhbiBpbmxpbmUgZnVuY3Rpb24NCj4gICAgeDg2L21z
cjogU2ltcGxpZnkgc29tZSByZG1zcnEoKSB1c2UgY2FzZXMNCj4gDQo+ICAgYXJjaC94ODYv
Y29jby9zZXYvY29yZS5jICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNo
L3g4Ni9ldmVudHMvYW1kL2Jycy5jICAgICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAg
IGFyY2gveDg2L2V2ZW50cy9hbWQvY29yZS5jICAgICAgICAgICAgICAgICAgICB8ICA4ICst
LQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9hbWQvaWJzLmMgICAgICAgICAgICAgICAgICAgICB8
IDE4ICsrKy0tLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvYW1kL2xici5jICAgICAgICAgICAg
ICAgICAgICAgfCAxNiArKy0tLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvYW1kL3Bvd2VyLmMg
ICAgICAgICAgICAgICAgICAgfCAgOCArLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvYW1kL3Vu
Y29yZS5jICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9j
b3JlLmMgICAgICAgICAgICAgICAgICAgICAgICB8IDIwICsrKystLS0tDQo+ICAgYXJjaC94
ODYvZXZlbnRzL2ludGVsL2NvcmUuYyAgICAgICAgICAgICAgICAgIHwgMTUgKystLS0tDQo+
ICAgYXJjaC94ODYvZXZlbnRzL2ludGVsL2NzdGF0ZS5jICAgICAgICAgICAgICAgIHwgIDUg
Ky0NCj4gICBhcmNoL3g4Ni9ldmVudHMvaW50ZWwvZHMuYyAgICAgICAgICAgICAgICAgICAg
fCAgMiArLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9pbnRlbC9rbmMuYyAgICAgICAgICAgICAg
ICAgICB8IDEwICsrLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvaW50ZWwvbGJyLmMgICAgICAg
ICAgICAgICAgICAgfCAyNSArKystLS0tLS0tDQo+ICAgYXJjaC94ODYvZXZlbnRzL2ludGVs
L3A0LmMgICAgICAgICAgICAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYvZXZlbnRz
L2ludGVsL3A2LmMgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9l
dmVudHMvaW50ZWwvcHQuYyAgICAgICAgICAgICAgICAgICAgfCAxMiArKy0tLQ0KPiAgIGFy
Y2gveDg2L2V2ZW50cy9pbnRlbC91bmNvcmUuYyAgICAgICAgICAgICAgICB8ICA2ICstLQ0K
PiAgIGFyY2gveDg2L2V2ZW50cy9pbnRlbC91bmNvcmVfbmhtZXguYyAgICAgICAgICB8ICA0
ICstDQo+ICAgYXJjaC94ODYvZXZlbnRzL2ludGVsL3VuY29yZV9zbmIuYyAgICAgICAgICAg
IHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9ldmVudHMvaW50ZWwvdW5jb3JlX3NuYmVwLmMgICAg
ICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9ldmVudHMvbXNyLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9wZXJmX2V2ZW50Lmgg
ICAgICAgICAgICAgICAgICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy9yYXBsLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2V2ZW50cy96
aGFveGluL2NvcmUuYyAgICAgICAgICAgICAgICB8IDEwICsrLS0NCj4gICBhcmNoL3g4Ni9o
eXBlcnYvaHZfYXBpYy5jICAgICAgICAgICAgICAgICAgICAgfCAgOSArKy0tDQo+ICAgYXJj
aC94ODYvaHlwZXJ2L2h2X2luaXQuYyAgICAgICAgICAgICAgICAgICAgIHwgMjYgKysrKyst
LS0tLQ0KPiAgIGFyY2gveDg2L2h5cGVydi9odl9zcGlubG9jay5jICAgICAgICAgICAgICAg
ICB8ICAyICstDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vYXBpYy5oICAgICAgICAgICAg
ICAgICAgIHwgIDcgKy0tDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vZGVidWdyZWcuaCAg
ICAgICAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vZnNnc2Jh
c2UuaCAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9r
dm1faG9zdC5oICAgICAgICAgICAgICAgfCAxMCAtLS0tDQo+ICAgYXJjaC94ODYvaW5jbHVk
ZS9hc20vbXNyLmggICAgICAgICAgICAgICAgICAgIHwgMzkgKystLS0tLS0tLS0tLS0tDQo+
ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICAgICAgICAgIHwgMjYg
Ky0tLS0tLS0tLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9hcGljL2FwaWMuYyAgICAgICAgICAg
ICAgICAgICB8IDE0ICsrKy0tLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9hcGljL2FwaWNfbnVt
YWNoaXAuYyAgICAgICAgICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jZXQuYyAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL2Nw
dS9hbWQuYyAgICAgICAgICAgICAgICAgICAgIHwgMTQgKysrLS0tDQo+ICAgYXJjaC94ODYv
a2VybmVsL2NwdS9hcGVyZm1wZXJmLmMgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJj
aC94ODYva2VybmVsL2NwdS9idWdzLmMgICAgICAgICAgICAgICAgICAgIHwgMTIgKystLS0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L2J1c19sb2NrLmMgICAgICAgICAgICAgICAgfCAg
OCArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NlbnRhdXIuYyAgICAgICAgICAgICAg
ICAgfCAgOCArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbi5jICAgICAgICAg
ICAgICAgICAgfCAxMiArKy0tLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvZmVhdF9jdGwu
YyAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9oeWdv
bi5jICAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1
L2ludGVsLmMgICAgICAgICAgICAgICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9rZXJu
ZWwvY3B1L2ludGVsX2VwYi5jICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2
L2tlcm5lbC9jcHUvbWNlL2FtZC5jICAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJj
aC94ODYva2VybmVsL2NwdS9tY2UvY29yZS5jICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+
ICAgYXJjaC94ODYva2VybmVsL2NwdS9tY2UvaW5qZWN0LmMgICAgICAgICAgICAgIHwgIDIg
Ky0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9pbnRlbC5jICAgICAgICAgICAgICAg
fCAxOCArKystLS0tDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9tY2UvcDUuYyAgICAgICAg
ICAgICAgICAgIHwgIDggKy0tDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9tY2Uvd2luY2hp
cC5jICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L21pY3Jv
Y29kZS9pbnRlbC5jICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUv
bXNoeXBlcnYuYyAgICAgICAgICAgICAgICB8ICA2ICstLQ0KPiAgIGFyY2gveDg2L2tlcm5l
bC9jcHUvbXRyci9hbWQuYyAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYv
a2VybmVsL2NwdS9tdHJyL2NsZWFudXAuYyAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNo
L3g4Ni9rZXJuZWwvY3B1L210cnIvZ2VuZXJpYy5jICAgICAgICAgICAgfCAzMiArKysrKyst
LS0tLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbXRyci5jICAgICAgICAgICAg
ICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvcmVzY3RybC9jb3JlLmMgICAg
ICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL21vbml0
b3IuYyAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Jlc2N0cmwv
cHNldWRvX2xvY2suYyAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvcmVz
Y3RybC9yZHRncm91cC5jICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL2Nw
dS90b3BvbG9neS5jICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9rZXJu
ZWwvY3B1L3RvcG9sb2d5X2FtZC5jICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2
L2tlcm5lbC9jcHUvdHJhbnNtZXRhLmMgICAgICAgICAgICAgICB8ICA4ICstLQ0KPiAgIGFy
Y2gveDg2L2tlcm5lbC9jcHUvdHN4LmMgICAgICAgICAgICAgICAgICAgICB8IDEwICsrLS0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L3Vtd2FpdC5jICAgICAgICAgICAgICAgICAgfCAg
MiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvemhhb3hpbi5jICAgICAgICAgICAgICAg
ICB8ICA0ICstDQo+ICAgYXJjaC94ODYva2VybmVsL2ZwdS9jb3JlLmMgICAgICAgICAgICAg
ICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvaHBldC5jICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9rdm0uYyAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL21tY29uZi1m
YW0xMGhfNjQuYyAgICAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYva2VybmVsL3By
b2Nlc3MuYyAgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9rZXJu
ZWwvcHJvY2Vzc182NC5jICAgICAgICAgICAgICAgICAgfCAxNCArKystLS0NCj4gICBhcmNo
L3g4Ni9rZXJuZWwvc2hzdGsuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgOCArLS0NCj4g
ICBhcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYyAgICAgICAgICAgICAgICAgICAgICAgfCAgNCAr
LQ0KPiAgIGFyY2gveDg2L2tlcm5lbC90c2MuYyAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL3RzY19tc3IuYyAgICAgICAgICAgICAgICAg
ICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYva2VybmVsL3RzY19zeW5jLmMgICAgICAgICAg
ICAgICAgICAgIHwgIDYgKy0tDQo+ICAgYXJjaC94ODYva3ZtL21zcnMuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni9rdm0vc3ZtL3BtdS5jICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGFyY2gveDg2L2t2bS9zdm0vc3Zt
LmMgICAgICAgICAgICAgICAgICAgICAgICB8ICA0ICstDQo+ICAgYXJjaC94ODYva3ZtL3Zt
eC9uZXN0ZWQuYyAgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBhcmNoL3g4Ni9r
dm0vdm14L3BtdV9pbnRlbC5jICAgICAgICAgICAgICAgICAgfCAgOCArLS0NCj4gICBhcmNo
L3g4Ni9rdm0vdm14L3NneC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgNiArLS0NCj4g
ICBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiAr
LQ0KPiAgIGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAgICAgICAgICAgICAgICAgICAgICB8
IDQyICsrKysrKysrLS0tLS0tLS0NCj4gICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9saWIvaW5zbi1ldmFs
LmMgICAgICAgICAgICAgICAgICAgICAgfCAgNiArLS0NCj4gICBhcmNoL3g4Ni9saWIvbXNy
LXNtcC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGFyY2gveDg2L21t
L3BhdC9tZW10eXBlLmMgICAgICAgICAgICAgICAgICAgICB8ICAyICstDQo+ICAgYXJjaC94
ODYvcGNpL2FtZF9idXMuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+ICAg
YXJjaC94ODYvcGxhdGZvcm0vb2xwYy9vbHBjLXhvMS1ydGMuYyAgICAgICAgIHwgIDYgKy0t
DQo+ICAgYXJjaC94ODYvcGxhdGZvcm0vb2xwYy9vbHBjLXhvMS1zY2kuYyAgICAgICAgIHwg
IDIgKy0NCj4gICBhcmNoL3g4Ni9wb3dlci9jcHUuYyAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAxMCArKy0tDQo+ICAgYXJjaC94ODYvcmVhbG1vZGUvaW5pdC5jICAgICAgICAgICAg
ICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni92aXJ0L2h3LmMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgOCArLS0NCj4gICBhcmNoL3g4Ni92aXJ0L3N2bS9zZXYuYyAg
ICAgICAgICAgICAgICAgICAgICAgfCAxOCArKystLS0tDQo+ICAgYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5jICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBhcmNoL3g4Ni94
ZW4vc3VzcGVuZC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiAgIGRyaXZl
cnMvYWNwaS9wcm9jZXNzb3JfcGVyZmxpYi5jICAgICAgICAgICAgICB8ICAyICstDQo+ICAg
ZHJpdmVycy9hdGEvcGF0YV9jczU1MzUuYyAgICAgICAgICAgICAgICAgICAgIHwgMjQgKysr
Ky0tLS0tDQo+ICAgZHJpdmVycy9hdGEvcGF0YV9jczU1MzYuYyAgICAgICAgICAgICAgICAg
ICAgIHwgMTcgKysrLS0tLQ0KPiAgIGRyaXZlcnMvY2hhci9hZ3AvbnZpZGlhLWFncC5jICAg
ICAgICAgICAgICAgICB8IDMyICsrKysrKy0tLS0tLQ0KPiAgIGRyaXZlcnMvY2hhci9od19y
YW5kb20vdmlhLXJuZy5jICAgICAgICAgICAgICB8IDI5ICsrKysrLS0tLS0tDQo+ICAgZHJp
dmVycy9jcHVmcmVxL2FjcGktY3B1ZnJlcS5jICAgICAgICAgICAgICAgIHwgIDggKy0tDQo+
ICAgZHJpdmVycy9jcHVmcmVxL2FtZC1wc3RhdGUuYyAgICAgICAgICAgICAgICAgIHwgIDQg
Ky0NCj4gICBkcml2ZXJzL2NwdWZyZXEvZV9wb3dlcnNhdmVyLmMgICAgICAgICAgICAgICAg
fCAyMCArKysrLS0tLQ0KPiAgIGRyaXZlcnMvY3B1ZnJlcS9pbnRlbF9wc3RhdGUuYyAgICAg
ICAgICAgICAgICB8IDI4ICsrKysrLS0tLS0tDQo+ICAgZHJpdmVycy9jcHVmcmVxL2xvbmdo
YXVsLmMgICAgICAgICAgICAgICAgICAgIHwgMTIgKystLS0NCj4gICBkcml2ZXJzL2NwdWZy
ZXEvbG9uZ3J1bi5jICAgICAgICAgICAgICAgICAgICAgfCAxNiArKystLS0NCj4gICBkcml2
ZXJzL2NwdWZyZXEvcG93ZXJub3ctazcuYyAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+
ICAgZHJpdmVycy9jcHVmcmVxL3Bvd2Vybm93LWs4LmMgICAgICAgICAgICAgICAgIHwgIDgg
Ky0tDQo+ICAgZHJpdmVycy9jcHVmcmVxL3NwZWVkc3RlcC1jZW50cmluby5jICAgICAgICAg
IHwgIDQgKy0NCj4gICBkcml2ZXJzL2NwdWZyZXEvc3BlZWRzdGVwLWxpYi5jICAgICAgICAg
ICAgICAgfCAxNCArKystLS0NCj4gICBkcml2ZXJzL2VkYWMvYW1kNjRfZWRhYy5jICAgICAg
ICAgICAgICAgICAgICAgfCAgNiArLS0NCj4gICBkcml2ZXJzL2dwaW8vZ3Bpby1jczU1MzUu
YyAgICAgICAgICAgICAgICAgICAgfCAxMCArKy0tDQo+ICAgZHJpdmVycy9odi9tc2h2X3Z0
bF9tYWluLmMgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gICBkcml2ZXJzL2h3bW9u
L2h3bW9uLXZpZC5jICAgICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIGRyaXZlcnMv
aWRsZS9pbnRlbF9pZGxlLmMgICAgICAgICAgICAgICAgICAgICB8IDI2ICsrKysrLS0tLS0N
Cj4gICBkcml2ZXJzL21pc2MvY3M1NTM1LW1mZ3B0LmMgICAgICAgICAgICAgICAgICAgfCAz
MyArKysrKystLS0tLS0NCj4gICBkcml2ZXJzL210ZC9uYW5kL3Jhdy9jczU1M3hfbmFuZC5j
ICAgICAgICAgICAgfCAgNiArLS0NCj4gICBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9pbnRlbC9p
ZnMvbG9hZC5jICAgICAgICAgfCAxMCArKy0tDQo+ICAgZHJpdmVycy9wbGF0Zm9ybS94ODYv
aW50ZWwvaWZzL3J1bnRlc3QuYyAgICAgIHwgIDggKy0tDQo+ICAgZHJpdmVycy9wbGF0Zm9y
bS94ODYvaW50ZWwvcG1jL2NucC5jICAgICAgICAgIHwgIDIgKy0NCj4gICAuLi4vaW50ZWwv
c3BlZWRfc2VsZWN0X2lmL2lzc3RfaWZfbWJveF9tc3IuYyAgfCAgNiArLS0NCj4gICAuLi4v
aW50ZWwvc3BlZWRfc2VsZWN0X2lmL2lzc3RfdHBtaV9jb3JlLmMgICAgfCAgMiArLQ0KPiAg
IGRyaXZlcnMvcGxhdGZvcm0veDg2L2ludGVsX2lwcy5jICAgICAgICAgICAgICB8IDIwICsr
KystLS0tDQo+ICAgZHJpdmVycy9wb3dlcmNhcC9pbnRlbF9yYXBsX21zci5jICAgICAgICAg
ICAgIHwgIDIgKy0NCj4gICBkcml2ZXJzL3RoZXJtYWwvaW50ZWwvaW50ZWxfaGZpLmMgICAg
ICAgICAgICAgfCAgOCArLS0NCj4gICBkcml2ZXJzL3RoZXJtYWwvaW50ZWwvdGhlcm1fdGhy
b3QuYyAgICAgICAgICAgfCAyMiArKysrLS0tLQ0KPiAgIGRyaXZlcnMvdGhlcm1hbC9pbnRl
bC94ODZfcGtnX3RlbXBfdGhlcm1hbC5jICB8ICA2ICstLQ0KPiAgIGRyaXZlcnMvdmlkZW8v
ZmJkZXYvZ2VvZGUvZGlzcGxheV9neC5jICAgICAgICB8ICA4ICstLQ0KPiAgIGRyaXZlcnMv
dmlkZW8vZmJkZXYvZ2VvZGUvZ3hmYl9jb3JlLmMgICAgICAgICB8ICAyICstDQo+ICAgZHJp
dmVycy92aWRlby9mYmRldi9nZW9kZS9seGZiX29wcy5jICAgICAgICAgIHwgNTAgKysrKysr
KysrLS0tLS0tLS0tLQ0KPiAgIGRyaXZlcnMvdmlkZW8vZmJkZXYvZ2VvZGUvc3VzcGVuZF9n
eC5jICAgICAgICB8IDI0ICsrKysrLS0tLQ0KPiAgIGRyaXZlcnMvdmlkZW8vZmJkZXYvZ2Vv
ZGUvdmlkZW9fZ3guYyAgICAgICAgICB8ICA4ICstLQ0KPiAgIGluY2x1ZGUvbGludXgvY3M1
NTM1LmggICAgICAgICAgICAgICAgICAgICAgICB8IDEwICsrLS0NCj4gICAxMzggZmlsZXMg
Y2hhbmdlZCwgNTc1IGluc2VydGlvbnMoKyksIDY5NCBkZWxldGlvbnMoLSkNCj4gDQoNCmFu
eXRoaW5nIHlvdSBuZWVkIGZyb20gbWUgdG8gZ2V0IHRoaXMgc2VyaWVzIGludG8gNy40Pw0K
DQoNCkp1ZXJnZW4NCg==
--------------dtnWD0jmGt0coRzSWi6oU7rk
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------dtnWD0jmGt0coRzSWi6oU7rk--

--------------T4ZJp6Lhzy2IBIrjLpBsTTw0--

--------------axxK79NgUHTDoQRwnbgWpSYy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmqxS/0FAwAAAAAACgkQsN6d1ii/Ey96
wwf/dV+nbtFwBzRTdTv3Vx2lVN89DL6TR+euiSyGZLTqPjp0pW5wAtoIwgj4xQNNKLWJK+HdGnQA
uIpKCGhzndQjA5/bYZLYAk0U5OVc1x2RrasQn0vel7msJTFqjW6fl3XNodJ40rFbpqoOYqFxBOIq
H0xe0vqCJ1u8yj9FZ5+NUOXlGprAqEgyUOFGWWrT237ejyqgKVVw6QS2d/7sDvXFyLeRkG6f/wfH
eiUguWe063lhXObtP1J1YAkzAMJBkTuG39L6Tde54kqVIQyIbk9voL4wDHeNYvIpyd2Mk2GSZ+ha
kni709pSh+qTNFkR5kCpypyUAeSKftAkqDpPz3fe1A==
=q3Lv
-----END PGP SIGNATURE-----

--------------axxK79NgUHTDoQRwnbgWpSYy--
