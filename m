Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243864;
	b=Rh+QG1ItC/tgehg6uPf5LRL8Ud2lzAhzOtJPt9P6xXLwBaRWjmuOax/mjxt+d5OUd9My
	 gx4ejphjzFdkqc/7oN1P7d2JhyP/ynvmfvDnlZJWp9VSBdZP8B37X8r2uNQ9/tWOx2yCk
	 2eO4QrIP/43Oe4kc+TDSHeSd7VODMqSo/KCZ+6TgNYCeE5pyNCFTy8glU3zViEBMsF4Jb
	 L3+sUiz0Xf6w4J0RWftAO208oLip2i0gJq0/46O8Baly2GznSi1IfPSuqJv/WB4RnZ5mt
	 TiO7Bugq1oT+pkbRpcJI/gdyLDDyR0CRP00aNlo+T1/tjfQFd0iGVKwKMA/jkxXgqLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
	b=eGZwOciB3drVwyUbIafUpUPFzoD9dGToZxnnk1sQiJal0qe7NXgyigdp4LyudjeSYrdK
	 P4T2QwQIdK5I72GGPhmTk8Ox/9mUCSKoewBUFvOUJtGU28OW9nt8Rik2/LL1BrTEGyI9Y
	 FQbwUrHZodEXG03LmV6Pj+QUEmb011EzyZyYeEk6Wk+Qlgd1eWWUE2ZCMy65Am4KkRNhx
	 4OFQVHTQkZu2V8sVnwjomaECpX2ZLojARpWfuvorlgMw1Atbv6SV32qXrLQBMyhy97Cch
	 2Q5RBrI+N9YZhApKxxcSdaDCCD70/tt5FUwwkKhCeSW9RIfgXkcjQrNWniDxWvgVjNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=INMhwymN;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2BF606A332
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 17:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F2BF606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=INMhwymN
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b571979178so1604998a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 09:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794243863; x=1794848663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
        b=INMhwymNUoXRa1HYjajYs2VDNOXoDzVIp/an3nVGMwTgqTKKIXcrYlToz3KguYeb2w
         0JSHPrAS4tp1u64diFxx98ot8r0Zd994Q5w09w9Wo7hRC/DtQLXBMMh5MnMbGm5sg/9+
         bfSbd1NNz976A12xlmIC5rBcyt2zgrNxYngASmeZZcCyhLh9b9uOIuPyOYnguxqTaeNR
         9hUslwRJlODcmrjO84K/MqZr6AW6G7obz3aQhSgpfQbvfDlBiGQqmaSqVNfiSLuoobIb
         SEhjw+R7G4bUMif5HGg+3AGlsX3R7zQQDPntqdP45khUAZLh8+Utt3l4+Gfo8W0GMqsn
         XheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243863; x=1794848663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VmhgsZdfI41q6bSk6Ws0aoyQukpnInOpVRPvZF0DgoY=;
        b=Jb4uZKo6+COeYrlMnVmDAvPIhCesTn6AUCABFgWDZyz6ra7HuIIAoQSgxy2XOkF+n4
         id74pzw9VM8l0uUT5uIhi1tg/6i/fD/dUMeyWXjBlEfgc2Rob6U9rt0e0NfvVeQExy7r
         q5Zv2vgJ0d28k5BcT1R/iKx4Bz7YtjyTIK+n/CoGa8kzBnsi/Kp9BwzmeosnH0BCUZTJ
         tKhg3UxL+YZ5eATls7E2La9B5C8RJ+ib4WipMIXmqpdAE5Q0ZkNdK8p/El7HOENLXBCq
         qYDEhTZoMaT673OHapvnaTTRbpqAzq5KQRsfw1nAyAru251pLPq9V1HEdFpxqxKWbTJo
         JdCw==
X-Forwarded-Encrypted: i=1; AL+hErEh9wvCTdNzIuUHE10QjbfcyPVbZZr0J6TkYgYCviKYfRGk+6mDeC+vYt/tgS0h4xRJtYuis6jTE5OvMgo=@vger.kernel.org
X-Gm-Message-State: APuU4Z+YL7iP1pejzdd02eVUyXt69w1aIi59k4n2F3Lfyiz8LfN5Ic0w
	lo9ml0zGBz/GYNn1nAHqo5K9xkZ+l+dgwfDLuz9NID0fEjj7MPbDgumm
X-Gm-Gg: AYBFou0/E9DKMUazLzOYmRipcnm8GdwiB+IbgLjevqKLwrynWNDa35EvPYd9i/4gnc9
	A7tizdXysowoO3BVwqxt25xMrcb4eOlqUj9wznezujyusptcGkZeCCeSh6cBEP+pXQScEKeegPy
	YFjqZBvmrwqiQF/oxK/gON0Z9yIovUCtSFLA3kaPfQXfBg5kYpDFW0hhE6PeZbzjA7GmXQiRmQb
	xbIiUPK0LbrMHImtyQBYf0GGnTA9O1jjKkhyaa5MvW28YUespl69qKqecN9YOsVEkXlxhbDRs7+
	Ukn+dH1KnE+uwoSbSA50toh1vqWRfsYIF9OdcQBxD1ZFM0Zab2irZDZo7lg2P6B7upPmfrKtq8n
	tfuJrf7/cDL6S0qD/GSrB2ss1tV3O5z3L+BwTzyhUv1fbSxfZtiGDDyx04gj4oG6DfdLDpYyU5Q
	WeuLZxuejr1INd1s5MZRjdzydzLilxngcxvhF8Ag6iU1oBT0jVs9Q7Rczu97UFeDFhgdZ37tQYo
	chulLB8Jt0nwtJqv2eFQbYcDzL4zBpKUOq+q/7zd2gmXRvwtIeT2p46Xu6DAhcONSA9afaHwTCy
	xFHbooI67kSHeQ0iWNG90fvSMoM=
X-Received: by 2002:a05:6402:2356:b0:6b5:7792:d82c with SMTP id 4fb4d7f45d1cf-6b756ad7482mr185305a12.16.1794243862514;
        Mon, 09 Nov 2026 09:04:22 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ebe31csm1878937a12.16.2026.11.09.09.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:04:21 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Lee Jones <lee@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
Date: Mon,  9 Nov 2026 17:04:07 +0000
Message-ID: <20261109170407.2073295-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-17-289114ab8197@gmail.com> <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 09/11/2026 16:12, Konrad Dybcio wrote:
> On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
>> +&usb_1 {
>> +	dr_mode = "peripheral";
>> +	maximum-speed = "high-speed";
>> +	qcom,select-utmi-as-pipe-clk;
>
> Is there no superspeed / dp altmode in hardware?

The headset supports USB SuperSpeed and DisplayPort via its USB Type-C
port, I just haven't brought them up yet. It seems we need a new driver
for the Type-C controller.

Stanislav
