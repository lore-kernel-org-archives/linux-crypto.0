Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4403B1CD13;
	Thu, 28 Mar 2024 01:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711589667; cv=none; b=l3/jQ27WCVi9twKStYsL8hMIQDTwqbNs6xIjfbmdavr2EQ9Uellf4Py6buS2G27QsC3yNbZqg5XMrikdq6tN/zg7wqzQFDETyGHlTSo+fvotiUzWqfeEGgQFpvyGMf8iNwLHP0nDfhMGfyhr4+Btyihu2UUoaXUAPjBebcdvZg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711589667; c=relaxed/simple;
	bh=L6xuTU/BIJ81u/Exo74EZKfqkItD2NhK9282T6fsiME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uyaXBqy1GFVU9Dzj4E6s/561jqDDXo03R5FyUfndwfi+Di93plv24N2ENUOitk5dDQci7pa1n3HWfmW8itCFyMkSSD6Ls2Mp47DbU3Ih40OxSwF+onJvmfp5HLIqWxS4mJJMIfgudx6ktuqtdkl8B58Nil+CgwxAWqwAwthfhu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpXJtoR0; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpXJtoR0"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5a522ae3747so203418eaf.1;
        Wed, 27 Mar 2024 18:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711589665; x=1712194465; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6xuTU/BIJ81u/Exo74EZKfqkItD2NhK9282T6fsiME=;
        b=gpXJtoR0LR9GA/dHxLdcxSKn0Rs+1Ql46+hQuc1IrhAPLqoPpYh0Yqn27GEtA5OLmG
         uyNXT2CVbuBJlsGAqF9wJ9DIq+4bKhI+eid13lN4Z4XdqKZ3TQmXHBIcUW2SawXwt5j6
         W83xKF0mUC15Aan4/JydQ/AJ4YjFJLs7+i0en0j9mfEDUfbNxuQ8grQ/fvYVtkw+5PkH
         BjoHKaJVtOsepk7cNJRY9Ez+NOr+zNvUnGPxttumXG7yEohWMpNrXM6EKNoq/bI97hqu
         oAVFkPTAijuEqhfmlhHga08vJiZK0N7E9hdMUTu6DzBfnw9m2s7F5DhDuLkRjTnlHh/2
         FYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711589665; x=1712194465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6xuTU/BIJ81u/Exo74EZKfqkItD2NhK9282T6fsiME=;
        b=ib47JnkBmo6HXyU/zsH0aPSMV6bPtmb/b5DgEelYgntO1RUzNza/LzKkphLIIZFiUL
         KWd8wN5R/1ra8VejHwGqiPFT7/AnhBm+PB//cpCMjHc9X6UzMrzneK+ww3CI4GIO0qfF
         /WaDR8qE5zUZtU7blchAhNkj9tQ9S2DEAMO5DWlQiWrVcDiuNLF/djAyPUWnO8jXMK29
         zVuNOgf2MiCaAdQNyMqXNDzV5fcbXNhYgUueHT0WIMxs+MW6Tcqnxp6VNBnMdYkYJcoQ
         DoOVn4dxf6M+JBppKdfCD0YdaZGmw69nDVcwWQ7mxetm4V5OWZVA6YyHBC+11y93ok4Z
         uzcw==
X-Forwarded-Encrypted: i=1; AJvYcCUb3VyHqrjK/KJ8yDG3hwkBvuDSV7crnowznCij69cpkeBzn3AVNJPyAcrgmVgXsEdBO3pjcz25u2QNb7tGSDr8db5yhPzABsFhFloGg5M+PKGEx0Q6Zn4CX4Ng8+GGzmh+OkIJgJ3j6IKMQVVbLRV1gyRdsrBRrLdvmR72rtGwFfNgpA73Fw==
X-Gm-Message-State: AOJu0YxoLJnWOJeHAogGfrjO7PUwnxoch/yO2EM8faYrv9eNFeOkXllc
	woMir+w28oN3ZG3iASNQ1Y1PKkhIrKlZjEVcm4TL580lisUbroPLu38ikTV4LiwjUXb9ZXJVjfO
	nOtWxHoYwtIS7udxiY0sIRYwfHx7owJGlPCnoXw==
X-Google-Smtp-Source: AGHT+IGXkuTKkhRtnqE/dOn/vFFQiMLFJ9Pr2hBPvSkc5soyRkaXFS1pB9IbOJgrTtVImy0f2Px1i+Uc3Bc4eOU+h3o=
X-Received: by 2002:a05:6870:2ce:b0:22a:278c:817c with SMTP id
 r14-20020a05687002ce00b0022a278c817cmr452768oaf.14.1711589665217; Wed, 27 Mar
 2024 18:34:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327054911.43093-1-animeshagarwal28@gmail.com> <20240327-attribute-stubbly-d09613567e0d@spud>
In-Reply-To: <20240327-attribute-stubbly-d09613567e0d@spud>
From: Animesh Agarwal <animeshagarwal28@gmail.com>
Date: Thu, 28 Mar 2024 07:04:13 +0530
Message-ID: <CAE3Oz81taAcXd-Zxx1rs=9v6C8BNs5_JdcfVk6op6=2W2S=msA@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: crypto: ti,omap-sham: Convert to dtschema
To: Conor Dooley <conor@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 10:22=E2=80=AFPM Conor Dooley <conor@kernel.org> wr=
ote:
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks for the review, Conor.

Regards,
Animesh Agarwal.
