Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A89A1C131A
	for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 12:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543596; cv=none; b=SHm1deN/aRwqGKGoRAsRumqlcfFvd5ArLFujzfS8ExuWR8XoKD+APqXLOEVC5dDO0uNIfCc0j2qZ1yrZcqLAecpwVYQ5UzhLnvRLTkRY010w0naFiWPlQUPi9Q8bpiycRG7InCKzgmfDrV5mIHX+IXbQRzioDjhc4dYAvhwUcGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543596; c=relaxed/simple;
	bh=NiQjVjMZFYqKExZsObNgm/DCszic+bAl+n8BqmPOZX4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fAb92e1ZogRWjcVhPpsqMw8IJ49VOq1Ky3+0wORHcTjVzoIifBntx+9Fy90NvWlbFGIQLZ+7mkhYSsEXlyMHM7ZEChP118svzfIR2Na1Ofe6oTeKZde4bpt7i9ZjnGbparUC9fAlYUNvVLRy+I/dB/n97vaYjE0WVjNLYSsFk+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bp653K+R; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bp653K+R"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a466e53f8c0so880870166b.1
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 05:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711543591; x=1712148391; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CAdnlTchQh8FlREm+ioloxT9FS6Bj5xt9o2Hrx59/ek=;
        b=Bp653K+Rn8/iKglnUWa6T9WJpFFyL7BJWCG1/jj5aGR2E6kkf0JRG5cIMVS4gSuG53
         RXvZGOpxSjeavke6ey7AAJCb9QMJkWPvdCb/cM+CFLXKILRwBaYx8WTBlh0DgQBQ7k5P
         JoC3ttMpWEqVnFec9S+t6WCl+iC06GzIaZiXk77rN5BqokBaqWsnR2xYPSVD+hdeo7mU
         9CotXiG5r2yadOi2xLea+8egijmVS463uq22QI5g8kVD3xkXdNLjerk6nyL45Uam91rW
         JdI1YcV3BHa0L7shxuoZqStnGzHVbgsdCnoI4IerBxdd6f0C40OX9D+iTRqBZwUc1/eF
         U74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711543591; x=1712148391;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAdnlTchQh8FlREm+ioloxT9FS6Bj5xt9o2Hrx59/ek=;
        b=ck0ZcVBrHeRd3cmkXkQGSf4iBBG14gppXmDPQ2DxrTPIZPhLv3rTc2afGtzl+ezX9T
         GQJ1FHVQSIZDDtmC7CqTEO/mM9hQY8z8ZwEYJau/OpYmJ171aHPoW2poaNLpYd1VGjNH
         gkCNLaJiiKvMhQu2U9BIpnOe+8zUSY9fJX5FGH8ZmsSZmLXGFSoxazksFii3Jz3/kIJy
         S9opWcuRczMTP4ehCFEgQ5RSsKgWX8pfiSig6FmzDBUJm1KZn+rJtCM+PnlA4puGuNp3
         vt+FctdAGaI1h5IUeXtUh8cixANvwsUVFFDxZTKdKPb8kfyKr8JmYkOHCNvuuAV6L/UB
         ALwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNddAZYJ+XAm7DlomB3c0ce6EdT8YU+qNcQt5YSyrrcy+JlrbQJ/AgnHxH6DBMjqeZNP7fbslIukNmlbEsOnI3xbdbzau19DoXAlfN
X-Gm-Message-State: AOJu0Yx2FCFsYnMb3MWiQNbT3epGDAzGJufU0oiYSa5ci2hZHI6+XbLs
	G65i5ZxfAVr0WrD0tprxITLEOL5sqkRW+can7ET5SA0eoenZPRkqEuyt7j5g4Xo=
X-Google-Smtp-Source: AGHT+IHVexc2kbCUunNAztPCJwdU2CYnVCIBBNG4v/92F/JNV3MM0F/SD/YxnW9+Oek5jxzlrpSwlg==
X-Received: by 2002:a17:906:411b:b0:a45:94bf:18e6 with SMTP id j27-20020a170906411b00b00a4594bf18e6mr908668ejk.73.1711543590897;
        Wed, 27 Mar 2024 05:46:30 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.206.205])
        by smtp.gmail.com with ESMTPSA id gx16-20020a170906f1d000b00a4707ec7c34sm5379175ejb.166.2024.03.27.05.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 05:46:30 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 27 Mar 2024 13:41:10 +0100
Subject: [PATCH 17/22] wireless: mac80211_hwsim: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240327-module-owner-virtio-v1-17-0feffab77d99@linaro.org>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
In-Reply-To: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Jens Axboe <axboe@kernel.dk>, Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Amit Shah <amit@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Gonglei <arei.gonglei@huawei.com>, "David S. Miller" <davem@davemloft.net>, 
 Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 
 Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, 
 Jean-Philippe Brucker <jean-philippe@linaro.org>, 
 Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, 
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: virtualization@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-um@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev, 
 kvm@vger.kernel.org, linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
 linux-sound@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=807;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=NiQjVjMZFYqKExZsObNgm/DCszic+bAl+n8BqmPOZX4=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmBBPo9EUYxSk0xH5wVhPIu64wDaxPpeXtcUWD2
 6lVJMlVdRuJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgQT6AAKCRDBN2bmhouD
 18pcD/9PLz7we290JB+0IIbADnjysV/3BADPsYqLnSwRZ4yb6P+wx41774nzlWugyWHJCX/j/Qk
 f+VNbcHKb1Lk8fXjgCCChiCYTBGnw5m0bpt+moBBHgE52CQ1Sw1WVjxr0tM525MyMYRhjhTDkfS
 kYK9PvEwCSBa/xhbwmcPEP6UCxmFXDMSPWB4utZ9Fc3QDnFca25zSRK/P1Xo3dHciiN6rf1IC9I
 jwQsgm8oEV40ThwOHxYN1YewOL/FD/X/mJgSZgJiWLBv1xnab4CS4BB6TAR507GDgMyASK76u0k
 Xx6KkPwpj+sPF+Qjz2EtV9ace5CEDfSQVRNDJNIcfkAvG9L6sEtTiiv7moMhIsgem25GeUPAH5P
 gVKYvaK9WZSveQjPc0rldRRiwmPYY9+q2qmDZPnI1qkd9Sw/aN8dvngQ2Lf0IIiV9LMwDRXfNaW
 06OmPJupRIH4tcBbWGCnbw06+oKJtRRLsaQsVwuWUuzKkkq63vHWnKHgNWziYufFjtfGqteyaxF
 Cyx/H6WNuU8GKMM5SVtD9O2m5Tu77YKhw7llT2eX1nAn0aWiH8ZPBCgVFFpuC0qECvOGYFRNx4N
 n3uKKbezBh5kkdYwgPZ5FoHNa/MFZoeUGMRLBiWFJhEUW8yIKmy9W+cC+jLtG6Vmac2xysrgU/Z
 8y6mEAPjW44Ba+w==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

virtio core already sets the .owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on the first patch.
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index b55fe320633c..ef38b7cc9fdf 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6662,7 +6662,6 @@ MODULE_DEVICE_TABLE(virtio, id_table);
 
 static struct virtio_driver virtio_hwsim = {
 	.driver.name = KBUILD_MODNAME,
-	.driver.owner = THIS_MODULE,
 	.id_table = id_table,
 	.probe = hwsim_virtio_probe,
 	.remove = hwsim_virtio_remove,

-- 
2.34.1

