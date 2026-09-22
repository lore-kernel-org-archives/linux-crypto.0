Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671541A503
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065356; cv=none; b=DewbDGMu/JvTYBCFjid9Aodcra9YG5BOekfcHmI9FgWzEzObXksw1w0fqes3f1QuWRKS9K3TTMGfAjFp29sDJRdB4g95ww3j4S51b1be12eqeQyReffuEY+LMyr7LjGxnfIPmN1ePKOzFm0HwGRrzJsPr+b4IBZkCiiglFzc/U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065356; c=relaxed/simple;
	bh=NdzYMIksNJSWd6DZYV8PauoE6FhKGoc4oC8+l3TBidk=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XJOMG/P2fI6odEdtZ5tXaN9pLUj7g2gjYfmHJmM6nFFk92SOujijUuep2bLLJmAM2kcGIs3+X+u06xMe8QJRpJj0iW0T5Hqi+Sis9Wc1eEPsoi7gTZnYGwe+wNDYc2tN0IIOK6qYn+7b5nk5sMay2957BcH46nGd8aZZtg/Rt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUQDEo/V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUQDEo/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC27E1F00893
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 08:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065353;
	bh=EvmHxqXCLy9EWZ/6cZQhXtH5A4Fz3V8fxmDhtm5wIEY=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=eUQDEo/VyBbty7zYwjUEuWbUnVXyxrpFbehq+ywlN21JMUY5QY5LQyol2y8nxGy6M
	 IFq4nNCNdU3YaoVEDrvipjNLXDzlOYWXTZ/bwFUEKnefzc+jvK2Z6XWkQf0o4BjWWv
	 pL7h6Q14BIpmO8cuK2ybx54SzbuJpYlhtycA9cGoks05pERHJf/B71L/kpcz1oYBQi
	 usl1PJNdfmXOYVJPWQN2SQuT6t7r0mXXHizDxoOU1pKAy2UXkdOlR7f2BOij2nL/Jf
	 z62oKFFafcy3tUsGkSIkPhMt4u6pGgkXRVBmfCilFJ8FhC1nOhA0pioIvsbao0Kmmq
	 EWvYD8/FEBiGg==
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff176d5bso31067971fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 01:22:33 -0700 (PDT)
X-Gm-Message-State: AFuF++l2EnIQZCFakRA1dlbUuFOP9QMoNq92rBcwL25Sf1d2j39m8yvI
	CWKWwNnIB9SjlKZnxNfWUq4/Su5uFWRoix0EXQL1ihS9KIgSvnYpZzDbltNP4xQP0BmQqkMTYS9
	6jRVzP2XLQJNAu/fJkh0jdFmz5cRmOGivrAt0vex07g==
X-Received: by 2002:a2e:bc16:0:b0:3a4:95f0:c5b7 with SMTP id
 38308e7fff4ca-3a5fbebf807mr28969311fa.3.1790065352455; Tue, 22 Sep 2026
 01:22:32 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 01:22:31 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 01:22:31 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 01:22:31 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com>
X-Gm-Features: AcwNN1VBTSPEWx1h-ie8zLso64KBEpFrX6miRGn5DdROKODYpn6wzkN3-uBIp-k
Message-ID: <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 21 Sep 2026 14:58:09 +0200, Bartosz Golaszewski
<bartosz.golaszewski@oss.qualcomm.com> said:
> This iteration - in addition to the previous fixes - proposes to split
> the QCE driver into a core part necessary to bind to the QCE DT node and
> enable runtime power management in order to allow to drop the
> interconnect votes, and the crypto part registering the crypto
> algorithms. The core module is then enabled in arm64 defconfig while the
> crypto part stays disabled by default. In addition: the actual
> registration of crypto algos is gated with a module parameter that
> default to false.
>
> Note that remaining reported bugs will still be fixed in follow-up
> series. This series addresses self-tests and disables the algos by
> default.
>
> The QCE hardware crypto engine has several limitations that cause it to
> produce incorrect results or stall on certain inputs. This series fixes
> several bugs and adds workaround allowing the deiver to pass crypto
> self-tests.
>
> The failures addressed are:
>
> - HMAC self-test failures for empty messages
> - AES-XTS returning success on zero-length input (should be -EINVAL)
> - AES-CTR: partial final block causes the engine to stall, output IV
>   derivation was incorrect
> - AES-XTS with key1 == key2 is not supported by the CE
> - AES-CCM: partial final block and fragmented payload both stall the
>   engine
>
> All fixes were tested on an SM8650 QRD board with
> CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Herbert: Sashiko still says it fails to apply. I have no idea why, it applies
fine on top of current linux-next.

Bart
