Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973B3364E9A
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 20:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782161607; cv=pass; b=tD/avzEVQSOLmj5MTsQurAoU76tqVWKW2/bj6R1Y4OdFgEs8D36XRwobUwaLg7wKzwizkUu4Zlw24ENZKFn4nCLvKoGapqQ37RZ6Afw9DbD0nsBzdIxklpqhHAtUZRM6+JqJMQAERW+Wp2f4Wqx1rZ7AaGVHM12xEj+PPUILuHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782161607; c=relaxed/simple;
	bh=IZlqlcNSuHxNQBV+rgdvf1lYfxlb8gM/yqEc6e36sNE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=E9FzdObYYOWUyd7tFz74pJB4taaLPzdNvqgCwuGwkqTpN5Q+2+iS3Q33NqZVKJsaGPEmPBZuZW72uMpg/ovni5PwYFV2MahVUl4gXrAExyPp96lcOB9EqjwglA1W+bFIjw7gxk4pcz9eLDjkPdIRbcJv9Yq1rrBlh1qU5lDMHi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbW/C39M; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbW/C39M"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c85d4b4245aso3453676a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782161605; cv=none;
        d=google.com; s=arc-20240605;
        b=jnUujIfikMAGvDosDvx5ZWpFedt4xYErx2CosvEtHTJgxUnLQAyyStP6yhQ7umV2tF
         Sn0LIosV5tvmtpeZenWAg1UstWmop69SGfYP63afGHnMhRAsK326chTGCQhJGrgizcMO
         FatjLhYAb4jHfA7tofBAURDgZcFeX37C5yZd7Y0FzTjwBSKjZlUzvZV8zsj5h7NJCvO5
         8ewaN1ixjYNDCwshx2/MYNAvDD6iMDsLwyG0AvnmDdYYuC70iK96PozBqHBZfUvxudLb
         m2oBo8TiFsXY1wipJnRQoJPMQBaVzsLMPJc9/6DqwaZ3QAAhZgWn7MMc2zHUwubPcPBl
         LBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=GP/vWkYY7RvVodKNR8gjRLk5ZQ95sE3bc8VVgjZKt5M=;
        fh=RJzevSfGHOesWS5q6dwOdSH02btAD/JPI5ISJfPGO+w=;
        b=CWs8NDOLSIhV/vjidqFpgIJBBR/os3GcmryB9Cu5XsL9flEUTg379sQJIw2ujNPQjx
         9BzHuvgtwCRj/IxsUkhAQnpper1q/HiQ2BbhWbevgLuTrMyrYj1CBvTFlh5WIzkACEWH
         uKhN8DSTj6FlGA2uxEOOVn2e3dcqPIdEguH63HzW/Q7JpRitN5IAEVjgBtDZX9D3tLIK
         g6WePuLAmU5MpnD1PaGJTPsMfxDJIwggI3d8O5BLk98JXwcCQxcQKM03Kmfvtr5f2dqT
         l3wEsQuu2S3X0Jd4hRIzDpfsTB8X2trPU/J0sm7PPSjFU2hRMzy4+v6xqfO6SIMSoheX
         QvtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782161605; x=1782766405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GP/vWkYY7RvVodKNR8gjRLk5ZQ95sE3bc8VVgjZKt5M=;
        b=HbW/C39MrTZBcWqZbqgnpVmxcE/gzyZiFfTdWPLDPfEmy1pX40yTBHgW1ylXvIka85
         jex7BcWtodwkSJGeWBTDs3fMV0H4O8xA66WingNI5iV/6j1o2oYqVBPkzjr42dBn5Fhs
         lFPQzebU+1WCqLkxL5gWu6/pADI3x13wyrWK3pkXPt+Hrug3WLEdhGbwS4pE9lsK060C
         9ec9maGcRjwZi4N3//PMIay2/Ijnrf1Nh/GGGG0gwbi5D41QBMeV2rxerfPAb8gWZ+W3
         nOAKyAXyyIO1qtk5xhwa90k9pxBKGsuCHhh7sbPyRicWC78Lk+NKXoxe0eT9+V6iu5MY
         dbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782161605; x=1782766405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GP/vWkYY7RvVodKNR8gjRLk5ZQ95sE3bc8VVgjZKt5M=;
        b=YSov1/Z/ych6+U8D9fMcia0yoLFZaQ77dIZIu3dRy29YUWK9sPwyMdey6oG6MF/3RE
         dhSD9sO3UPDk0t2TZ6+ZSLXpiiLf2rSMcgrpftQtD5Nm9dgq+ilQAvqxKTDqpxF9zRxd
         GYJVCtSVeU/bvrLpFwJ6igC9ekYtJwpZz3oDtS42wCB8cNCTS+rUnOP2kYBYm4hywyc4
         v9KS29j5NtRsh7oftFPJx9upYONdF7gFyUE7MXxQLJ3EEYmzgg1aG58ALqiMlQpeYpqd
         LgFdPTPo5Z2k6Z5JFhQmW+o5z5wAzFHuFETudKLryCSxg62c+x3kay6/C50YLbt6XhKN
         dTQg==
X-Gm-Message-State: AOJu0YyVRHUySxj2Yfruy8ktF66AnuqLvpmqhgocKPD5futn5fI+7wCH
	4TkfpQXWm4nt7ZRkl7k4B0OdUldMO46Ef+C+dZKAVVRUX1Y5KzK0mNg80w1Ddt95uhyyYzBw+xR
	TLmUPk3wP0Alxejdk/dUtRyi0M2ysmiZhH5FG
X-Gm-Gg: AfdE7cnV1qS08h6fOgiPPfsADkrXh3feanec2yeGBHxiPBJNE8vfLDTNuhxcI0er2VI
	YGoKjP2/sn4G3wHooxDFFZzh01C67IkebbLYMSOMFf1vB//umBWndxtfbB9xYokB+U38HqdYC/0
	15ZAgVFmCfugn+DTm6w+RGYewmhvBy9zz+m5PbzONSyBoWptLsU1mBcVgYtDXhnLzHk8wR9QcBr
	Nx+K2n7bCzyabdJ1nHmQtKRNlh9w3s+FDEMutfW+rLw8uTg43ch1mjH9AUIeUCKqRuVviUo+SiG
	WS6QCDdNjUZBmLfuEELTomlhd4xqrliM/fb9Q7gpiy2ROKG7dMnsEfF8plsE43i1xQTyzDUar9y
	cJFx32g==
X-Received: by 2002:a05:6a00:7493:b0:842:614e:cc8a with SMTP id
 d2e1a72fcca58-845508671a0mr13997611b3a.28.1782161605504; Mon, 22 Jun 2026
 13:53:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Jun 2026 16:53:14 -0400
X-Gm-Features: AVVi8Cc_3MAGXc4qVj_tNP-2UqZ0Z21x-Vat7MlydZ4qTJDzcP-wTktbrkXRRew
Message-ID: <CADvbK_ds7751V7_ss+GbDCjje4UigT2DY+31KO-5o5zP0mnJdA@mail.gmail.com>
Subject: [ISSUE] crypto: tegra - a call trace is triggered in debug_smp_processor_id()
To: Akhil R <akhilrajeev@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ 3968.199051] BUG: using smp_processor_id() in preemptible [00000000]
code: 15840000.crypto/897
[ 3968.199061] caller is debug_smp_processor_id+0x20/0x30
[ 3968.199075] CPU: 1 UID: 0 PID: 897 Comm: 15840000.crypto Kdump:
loaded Tainted: G        W      X   ------  ---
6.12.0-131.1473_2053543615.el10.aarch64+rt-64k #1 PREEMPT_RT
[ 3968.199080] Tainted: [W]=3DWARN, [X]=3DAUX
[ 3968.199081] Hardware name: NVIDIA NVIDIA IGX Orin Development
Kit/Jetson, BIOS 36.4.1-gcid-38375079 11/19/2024
[ 3968.199083] Call trace:
[ 3968.199084]  show_stack+0x34/0x98 (C)
[ 3968.199091]  dump_stack_lvl+0x80/0xa8
[ 3968.199095]  dump_stack+0x18/0x2c
[ 3968.199097]  check_preemption_disabled+0x114/0x120
[ 3968.199100]  debug_smp_processor_id+0x20/0x30
[ 3968.199102]  xfrm_trans_queue_net+0x30/0x100
[ 3968.199107]  xfrm_trans_queue+0x28/0x38
[ 3968.199110]  xfrm4_transport_finish+0xec/0x278
[ 3968.199114]  xfrm_input+0x60c/0xd90
[ 3968.199117]  xfrm_input_resume+0x20/0x138
[ 3968.199121]  esp_input_done+0x2c/0x50 [esp4]
[ 3968.199130]  authenc_verify_ahash_done+0x40/0x58
[ 3968.199135]  crypto_finalize_request+0x3c/0x90 [crypto_engine]
[ 3968.199142]  crypto_finalize_hash_request+0x18/0x30 [crypto_engine]
[ 3968.199145]  tegra_sha_do_one_req+0x4c/0xd0 [tegra_se]
[ 3968.199151]  crypto_pump_requests.constprop.0+0x150/0x2a0 [crypto_engine=
]
[ 3968.199154]  crypto_pump_work+0x1c/0x30 [crypto_engine]
[ 3968.199157]  kthread_worker_fn+0x100/0x2c0
[ 3968.199161]  kthread+0x114/0x130
[ 3968.199164]  ret_from_fork+0x10/0x20

These commits show that crypto_finalize_hash_request() and
crypto_finalize_skcipher_request() must be called under
local_bh_disable(). Maybe the similar thing should be done to NVIDIA=E2=80=
=99s
tegra crypto driver to avoid this warning.

56ddb9aa3b32 crypto: stm32/cryp - call finalize with bh disabled
a853450bf4c7 crypto: xilinx - call finalize with bh disabled
7f22421103c5 crypto: gemini - call finalize with bh disabled
dba633342994 crypto: amlogic - call finalize with bh disabled
f75a749b6d78 crypto: sun8i-ce - call finalize with bh disabled
b169b3766242 crypto: sun8i-ss - call finalize with bh disabled

Thanks.
