Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC26280A52;
	Mon, 14 Apr 2025 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744631809; cv=none; b=b4xcUA2tPrpbirH2KLYcSDIZ6FWTI3UR/KTxKqsgLBkbYEuIbNB649rfBWtPMzsebU4CPGjapQUvjeQEpxsVHiflljdNFprSA+dwXrIuuI+yjeW6Rd9A42YWwdyNVHueVlI5J6lEGLkXhz1uFYizrG+cuC8BvlaUL7jcBJ53opc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744631809; c=relaxed/simple;
	bh=3sEttiFjBYbDYr+5eBpF/Y/XgXUE7by7730ApTqP/BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upnk1WCN3WNfD7c2ywBHGJ9Safd3W56pc+HzJ3Of0Jjilf0mSNS+8gi94gcW6ypJh5fGKz/r171z1Su6b5KoSgkgNUiX5P7dsNs+toejhap9FZGJ39gq96j4hgfQZCgghhQd3qKJA/M+mDZCTwN4sJERT0BA45iaGp3ihX9sMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5uvwQ1f; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5uvwQ1f"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3914aba1ce4so3578744f8f.2;
        Mon, 14 Apr 2025 04:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744631806; x=1745236606; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=27blyDXAmQsVOsKFI9FbgvEj0N3VDQZVe4EB+Ij1Y8E=;
        b=P5uvwQ1fpJPiCWYnfu2jplgiCq9fBpGICz7yJ3TsFQj8uMou2eOpSEZ1dElExRzRPR
         +Bet+3tlqi4AiDQBKGnNpog4PqEmGBJ2QGFMQmL8G5oaGmWV+EdR7i/OC5m3kTsnMPeF
         oC2EeXHHcyui/yvJkCbNaSR84thpC+rJGtQINn5c17yeY41n94OAD3c6UyDsv8N/khM5
         FQir5Twmt+rN+Rzw8mFnkECHTENbYi+ghRtGacF03zPh/Xr/dT2sAUYVjeY1zPR9+hdZ
         BlIOIIs2e1ZiGVePYi0S5Cj5YNyKPL0XQTAh8SvTZEJmJZMNseKqyw375tgfjMN7v4XP
         5tLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744631806; x=1745236606;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27blyDXAmQsVOsKFI9FbgvEj0N3VDQZVe4EB+Ij1Y8E=;
        b=MqToYP93GscLbs17PjJ97UbEfjbhLyFRx5vmrwrslcm9ruN1oPgtLRPf+yQ/K8ZwvU
         2S2UMrRYZ6j/axNtOwa/n4z0LdJ0HKqHx5VLNEcEcA5v3coAvCyooUAWRmLoSJS6vNYH
         QUSaqj3SGIp77q1c9oEjnBicqDqJMO+OMDBu/V0fweiEvPHD9Y1jfJ2qR3/Vea7Bhal+
         6XQm9vhm9LsxOzxX9DDN91lAOA5XKIbxh8+RlGXRl0Sz0Whx+UP6/NYZtUeUKAMp0eWH
         xS4VtTGxPHmmEAmRvwD4hcCppdcLrkekdW+w48r5TcHFm9Wp4fP+LeymCNcXkTgbOzTl
         +tAg==
X-Forwarded-Encrypted: i=1; AJvYcCUPYtR3arGf2DoaiL1h3SULPJYz55hPXhAn7YS/Ox3IF6VCtfXFH5fcmEfuetUnhPBkPRcnkXHlH0Or/KY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmtf/fqPlYyEwkxF9wDgGJsZyQH+Ki9wbJ1lJ2SV7QlQmt/KgP
	rEnRcH297QzvEkZQ2EWHJGZCneVw4mSw0jxoTzsYP9cHvfQeTSek
X-Gm-Gg: ASbGncuIKh3dixc5Jg480GjgDw6VnSQEnk0nfCrMT9Q8p2owbBEKWSqU1CF8/Jzell0
	xrWGpuo57MXGvZ1dYuJAvV/pt9WPDBYRqIeCBW/2GlM8D+Wm8TgoZvmGEqeREgeP/7d4v404HUx
	QTKcBOvno9tK1Ha/nzxVEOvYuqRm3bkyqxHm4lhP3rO8aYgyiwuem5PVk+UbOjxy2bTI8YWLN+2
	Jl0p0eo+jZqIRaUKff7efZGWZFaKScOOA4L9pKDBdGKCc7IzJDV/bS6r5MLTCPhc3pqDBrX8Bwz
	u8H9yONqz02xxFw3/h+wROstnb1eOXB2A5tg34mx
X-Google-Smtp-Source: AGHT+IGj7Vl3mhp98LI+iMc6cVdaQkfgWL6li+cKl/2bRIaqhFJ3JwH9UyrUXt2MUMKwXfrTR1rG+g==
X-Received: by 2002:a05:6000:144b:b0:38d:e584:81ea with SMTP id ffacd0b85a97d-39eaaebeadamr9595715f8f.45.1744631805537;
        Mon, 14 Apr 2025 04:56:45 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43f23572c4esm176735115e9.26.2025.04.14.04.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 04:56:44 -0700 (PDT)
Date: Mon, 14 Apr 2025 13:56:42 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-kernel@vger.kernel.org,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/4] crypto: sun8i-ss - use API helpers to setup fallback
 request
Message-ID: <Z_z3-kNlDoh4ly9T@Red>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
 <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>

Le Mon, Apr 07, 2025 at 03:36:03PM +0300, Ovidiu Panait a écrit :
> Rather than setting up the fallback request by hand, use
> ahash_request_set_callback() and ahash_request_set_crypt() API helpers
> to properly setup the new request.
> 
> This also ensures that the completion callback is properly passed down
> to the fallback algorithm, which avoids a crash with async fallbacks.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
> Cc: Samuel Holland <samuel@sholland.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-sunxi@lists.linux.dev
> 
Hello

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
