Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9703AF674
	for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 08:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791621776; cv=none; b=f+ht+0YzX1/83sEYqEN9+0gSmOlhxlQDdPEdFDEPmO+mVXuEvuIndOjh4Pe5Ufj04nUj+D7eVln4D3QqClrPETYOgENXvHciEWeKks98kyOIsWpl4poffSs0ubVIiKoZwRyb7p+vu87VVbY2wSdFNUwJcOQUyvCeAwsWOZkQUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791621776; c=relaxed/simple;
	bh=T0cHhk3sVg14STn5ch68EKKiVtS63d3OH+IINR9SoUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kw4BqvRG2qL443zzTcJhP1pVSVHaroSGgA0qKDZC+uN/8+akmW8DYy+XYzjqeB7fBWIrntq3uIKJWqqLTHWoO7jhx1MBTcF0obn3PXTgBwnWa/cAPEGQ5w9Dw5u0Px3jY27wAnZBVXMEZYhhHl6EJPXWtC/lvFRlMHqvslFpvc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Fo5lzCKR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U60NLG4u; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Fo5lzCKR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U60NLG4u"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69A2pjqY4150807
	for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 08:42:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IqymoQ2HDibV8WA0yhfluVKdlQdB/7YbmVl1gD2ORD8=; b=Fo5lzCKR6ouvQqMF
	AfXvk7qHNy+UGr0uB/I75FzhO/oHguIgOagvJ50C1NXQUikQfyJk79H9vjFIlnjB
	bgTjhV8vSzS4dPkTiu8g6i4oO5GZS5Hbva9CkwhMzsCPgcJ3se2tzthEO1U0YM/h
	qqKO+KNKfG+Bwtqnb1VFRRoze4vVy6qBoY+WTKXije/fNbbTy3NigBrpI1x3+A0r
	uIlAHrfVf71v/5ji4yntBkpw+jq2Bhy0bKyGz9N8eUDWvzrEPHJpKe+wvJJZUPau
	BceKIvfkXsLXb5ZCrcR4QKdS/cROb9qNkdQ3r4GI9dt4fqy1ey8vUMAPPuUjd38K
	cYoPsA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h7cxxgp1b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 08:42:52 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cb7f9bb86so80387785a.2
        for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 01:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791621772; x=1792226572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IqymoQ2HDibV8WA0yhfluVKdlQdB/7YbmVl1gD2ORD8=;
        b=U60NLG4u3jcimbiOPlvSarsUzmhvlmXgWTlCnjWhoSzx88fR7emY9fIESym/zdGUq9
         TNqkL1VvcZpcVAOR2d75f+VHusG0uKzayhYghy0XhqAtPCcUVqxqlegihXsG0HXI6xyp
         qSW8SyjefBsBO27P6SuVQQuDa+hrf5kWcfDK+2AtBQVgNJzbFVqK050FmZ96UD5WkbZp
         Ml0T1i/PBshz87SgQX8AC6OWBuRoAaJRucuP+cLWifmRn0lagzyOrl/uufGfCP4uejlj
         3DWhGJt3gJfXxk2HiHSGYABaNDXmUoutJyX3nS99GpYu8bL3Mjb9AFmlXt+5QOAqh06n
         bVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791621772; x=1792226572;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IqymoQ2HDibV8WA0yhfluVKdlQdB/7YbmVl1gD2ORD8=;
        b=mEscZEXhBzNv7Iav8jCaV91SGmnjKoa/AJKSgxh+FIO39C3wRvyaImTUMb3NtlFm/6
         MPI4gnhtb8nhdeNl5X5viW9edmzRSZkQ2bM0yncJH/CQIU/A7FOqN/qqSBVXLY0eQAf1
         usH8FtSlmLrvgiDl3JYVgi8RoqT3Zlb2ST19r9WBjZ34cQiNuLtAwxw8vwZOHCrIQBGX
         n7KX87UMi/2/hu902y3RamKrQpIp6IVBZWGXhZ3UUBtcHdWbAkMO4CxtH5peUl6xDlFA
         +tWTCr949AtMh2SlXslX9VscfTjXWqlADKEGYX8pZL26w2mlyH9opelju+mDOWfyfZ9Z
         3YPQ==
X-Forwarded-Encrypted: i=1; AKwUvBz/z2EA2/g/fTy2JIUd+WKhyX8UkqJOxPzNtSGoVaXV2s7b7f1i9u9UiLYf+pYCGSseD/Owe+dpw7iacxY=@vger.kernel.org
X-Gm-Message-State: AFq9FYLzgA6VTob63ZWWrLbDJx6lsCBLrZiKTo9rBXh/4lc6a3sKmYG2
	2OvfmdBv3rQI+KH5MMMdxdQUZH3m1vHWK1+iXlYimj6w938XzsVd0LOYWfppRB6MPcZlGv9n8y8
	rNc4tcW77hL7pD5v46/x0ddxNBB7khgxk77glEofXKqsJ/i937+vrnuk/0hOpi+uFlt4=
X-Gm-Gg: AYBFou2Fjz1XVnFz9o/IUQnbLeWQLKKRhRL4v4nuXIgs7ar+bKxiCA1YXi1avmBxdVD
	P8Gqrtpq3KDojlybMepFMAnJg1+BUX4G/kcb6faKXG4X1hVXnfC+kPV/++v8MQdhEEg40cLiEF6
	TcdwAtQj7yb/v0R+SLCHFy/JUnAMSnS71ibQzX6/6Kx5exMxgXTJSb5vmuKI8Yp50X3Pk3BcIhP
	ICVLqA8Lciyrvsh3BcwjuJ50xP13poCY9sdUmL+a5dwPDY4u8a5Ix+puAIvjyRa4KZB2Z+s2BJV
	UlbzVh5IzTAx8aIM4t24fMDGeRUHnYZWLtiisiwY51H1lHce625UpST2V9LvQpP07nU2lmYNIah
	4nAsICQs/mqABq/rpGuRrlhc7EfSW7Kvbq5QOFBE9b3MHyu4BR4k=
X-Received: by 2002:a05:620a:4146:b0:93e:5929:f012 with SMTP id af79cd13be357-93ebd1bb215mr668128685a.18.1791621771765;
        Sat, 10 Oct 2026 01:42:51 -0700 (PDT)
X-Received: by 2002:a05:620a:4146:b0:93e:5929:f012 with SMTP id af79cd13be357-93ebd1bb215mr668125985a.18.1791621771276;
        Sat, 10 Oct 2026 01:42:51 -0700 (PDT)
Received: from brgl-qcom.local (126.171.88.92.rev.sfr.net. [92.88.171.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a192d3efb6sm49065585e9.1.2026.10.10.01.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 01:42:50 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>,
        Brian Norris <briannorris@chromium.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-pm@vger.kernel.org, Ulf Hansson <ulfh@kernel.org>,
        linux-kernel@vger.kernel.org, Bryan O'Donoghue <bod@kernel.org>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Alex Elder <elder@kernel.org>, Andy Shevchenko <andy@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        David Lechner <dlechner@baylibre.com>,
        Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hadar Gat <hadar.gat@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jaroslav Kysela <perex@perex.cz>,
        Jessica Zhang <jesszhan0024@gmail.com>,
        Johan Hovold <johan@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
        Jyri Sarha <jyri.sarha@iki.fi>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Linus Walleij <linusw@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Marek Vasut <marek.vasut+renesas@mailbox.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <mripard@kernel.org>, Melissa Wen <mwen@igalia.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Olivia Mackall <olivia@selenic.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Srinivas Kandagatla <srini@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
        dri-devel@lists.freedesktop.org, greybus-dev@lists.linaro.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-sound@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-staging@lists.linux.dev, sound-open-firmware@alsa-project.org
Subject: Re: (subset) [PATCH 00/13] PM: runtime: Convert pm_runtime_put_autosuspend() and friends to a void function
Date: Sat, 10 Oct 2026 10:42:36 +0200
Message-ID: <179162175231.5836.15015381844446264252.b4-ty@oss.qualcomm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006231900.3230373-1-briannorris@chromium.org>
References: <20261006231900.3230373-1-briannorris@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Wau2iiXd4nFqfTWh3c0SypPMFgSKfrSE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDAzNCBTYWx0ZWRfX8fsjZqLZQiMx
 rz5VNnXEx/xf4dCr7aK2BGBTnmB3q4D9YeYBjt0ciuYIw22XJyByOkMHP9kf5g46BqSG3U2oTUE
 Vbc598S4AQFK11i+2L6R5kAQYjBGhNU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDAzNCBTYWx0ZWRfX77V2XeKgO6iN
 WEzjDnlaihzsgCJTS7I34m+9X1XHa5GIgseYuG5CYl9oWVJ+djv7wpH+gdPOnE2bkXjXTz5ifmN
 /QiSM+QTI2wkgokoZFB44tyz0cGC6WyU/CLdEgW8B/vi2IEpuI/7jL8DWQa0pxPPA3BH6B5jylm
 ubSQlSNDSiwzsOE7FEd4sqJsPG9yW19ph/cmuSlaNhuuoVh4Od0N2gfJGLfq2XnAKL1aZ9hZnFQ
 Di0OczbTYULDUyOaly/oWdbColOMdMm1/vs806/jn4ss2ztjbZD4a6cGnlwHt4FR0Fpwg6bXdG5
 8lUnvhjUs0RMS05abd0gJD5DGurfK8kldKpL5YVSzXgEdZYZILTBwllQalQP9F2wRDppH+hOaUx
 z2Gm6s758aZnZLNPqIgeaSHV2qwI42HpDSIWLmMz3R16rgtmGN2pk72hAO4/gwtw/c6YLayrJjY
 WSifa7xdtuFSX8EcLIQ==
X-Authority-Analysis: v=2.4 cv=AsJ7T+9P c=1 sm=1 tr=0 ts=6ac9fa8c cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=3oaWUOhNWTYPA9BJS75j6A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rmSHi3-zQwwJBmM97rsA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: Wau2iiXd4nFqfTWh3c0SypPMFgSKfrSE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-10_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610100034


On Tue, 06 Oct 2026 16:13:28 -0700, Brian Norris wrote:
> Similar to this effort:
> 
>   Subject: [PATCH v1 00/23] PM: runtime: Convert pm_runtime_put() to a void function
>   https://lore.kernel.org/all/6245770.lOV4Wx5bFT@rafael.j.wysocki/
> 
> i.e., commit 3afd8df02433 ("PM: runtime: Change pm_runtime_put() return
> type to void") and friends.
> 
> [...]

Applied, thanks!

[05/13] pinctrl: qcom: lpass-lpi: Discard pm_runtime_put_autosuspend() return values
        https://git.kernel.org/brgl/c/9bcd1725b0cc7954525e3d0d02fecaec7c7aab33

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
