Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7824378D8A
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075782; cv=none; b=ZyQx9rtrNiBRQEgh3Wa41iNJSsYjUCSqvj3UACKgOjfsVciMr9GV9Ndu/4BCeQCnCkDV7+7S2PjczH77maAlFmxNxppVZNo79dUnYpc7VVt0I7KsADWvi6NG0Tw0NJtPkiHZAXdLWFTuGvuU3xPlK5pxQ8Nj5F5rDD+4joZBBOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075782; c=relaxed/simple;
	bh=bXOaVPd7VhD3hx5c4q+vgR03AqUTjEWUn8n5s3ly05A=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gkFidkD/yNIV27Bo9wlOgFYm+iY/4SVlZY4M61A2EPpgS5WjajhOcN6sHDq3Xwq8uc8cDH8d+VNPeRykfmegWCtKytblp4Ud3lE6Aqe/7AQREozeU0mWnSKRDNx6gtuOwW+4Fm9micJEDtYPVZy9Mnea8dVjdXEi9TJLfs5O5rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8oA7GN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8oA7GN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF481F000C8
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 14:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075781;
	bh=bXOaVPd7VhD3hx5c4q+vgR03AqUTjEWUn8n5s3ly05A=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=B8oA7GN6JsazgwX9l+5E+BX3cveXGzUU5AaLdW/hyXwEN81ID2UO3P2hJFqtIdCtU
	 LNaRJlToWhCmJP/p+0iV3qxkdEC91IuHyEoQehF9T2YQ1GXyX+hhfjWEYDHooJX7Qz
	 jR0XuQSc/rZfG4Mq2JhJ1BoINejHBwzVuNXQRn8objGh1TPeoWjK6oDqDr8rN3k9/q
	 OCxL28Vm5nR7NMuyeT1r6Woacyl+1XmV8WGqfG2gdOapWn+AaTyWMi8JQlqbMgwGJd
	 I+5l+UxWKUzoaaiMsUIaoNGpoys60qHq88GFiQa7LvzmaIMK0wBWgB161E6hc2KwMh
	 m/f7N8shAGqhw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so3805662e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 07:49:41 -0700 (PDT)
X-Gm-Message-State: AFq9FYIaW3WIo7HDGuzpCcnUB2nuwQOSYqCq3MwQy1McopZ1rMiGdWfy
	eAuu7jdY+NiHdEI42zMXPTbgZDzTwHgYmCPlU/4xqHdZUqe3h6UFrGbsKMPRZKCHk9HasimHab3
	Wsr58/RbXVj8qYo3bntLolndyWlS7aTzQtOmu0NhWpQ==
X-Received: by 2002:a05:6512:3e04:b0:5be:3db4:5665 with SMTP id
 2adb3069b0e04-5be3db4582cmr863547e87.7.1792075780254; Thu, 15 Oct 2026
 07:49:40 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 10:49:37 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 10:49:37 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 10:49:37 -0400
X-Gmail-Original-Message-ID: <CAMRc=MejhYpC6QNXwK_cG_NuJs5XpOviK2NPsEwtnK0RxDi61Q@mail.gmail.com>
X-Gm-Features: AclHuK99R8-us8Fs2p5d0092H4vgTDHcFapELNpNx1Z9qKaqccwjS9iFs8yerts
Message-ID: <CAMRc=MejhYpC6QNXwK_cG_NuJs5XpOviK2NPsEwtnK0RxDi61Q@mail.gmail.com>
Subject: Re: [PATCH v10 00/14] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Stanimir Varbanov <svarbanov@mm-sol.com>, Eneas U de Queiroz <cotequeiroz@gmail.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Eric Biggers <ebiggers@kernel.org>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Oct 2026 11:57:29 +0200, Bartosz Golaszewski
<bartosz.golaszewski@oss.qualcomm.com> said:
> This iteration addresses issues raised by sashiko.
>

It came back with some more issues. And seems I have a build failure midway
in the series so that needs fixing too.

Bart
