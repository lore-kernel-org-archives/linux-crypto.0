Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668C91115
	for <linux-crypto@vger.kernel.org>; Fri,  1 Mar 2024 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709296596; cv=none; b=mnSwqugkpxWYUtTOQc8Zx9kGEL/DZAMM1GOxK2oB0BaQ1+iSKLzvnLDMgKrnKoH/ctNgOyzft+80VCR4/wMqKTjsUW/D7aPtqaYJyqcpEV84eu9xNCqv1Vh5Pgz0pW9ENPNt5byYGZqPA9hWNEm3wxRl/ydJYts9kxBW5r7NWIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709296596; c=relaxed/simple;
	bh=46QQdgNfVCnY0kDCTnTRBIKamFFvFvZLtfXf6iIr6kA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=J4u8epc5hfuBJKHZf2fUXPMjhNNFHok6upAXBq4Wt54YdhHOQl0da1LtcGAyq6Bd4z9DnW05dVCLLhWndoQ8ipZCSdgbNp574lKrk6XZihg86tx02FTXbkgQsQZ8b46nw+/WtG0aeCQiiLmDpxaLhQvUT6NLbSBjWh/B8zNsr/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQu6g3pV; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQu6g3pV"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a0deaf21efso1118045eaf.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 Mar 2024 04:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709296594; x=1709901394; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=46QQdgNfVCnY0kDCTnTRBIKamFFvFvZLtfXf6iIr6kA=;
        b=ZQu6g3pV6jRuYFXEpvsI93TCvrSomvNZH58rzPAeWYVZjM8oACGd2+qnxdrY63Maiv
         iezRwunbxuGHROflfO7bbgfpvXj9qlOBmkkR0RnS2EIdqsFfyyRPsPWXbeY/bt4uY9R+
         C9OvUW0DiL9vFAI0spGxWc7JsYZxX+y06p3sY/S8Ddu5Cl0LVoFq1EfHZiVs2T4q5iuS
         LePitR2yYwfVY/T5mht24bmsWauv09dOX/12Y70NUr4sVH4defAN4OpesLoGqVLJ8gVM
         pS6PhYQupOlMA5LY6UW30o8SAV3aZFO9vXV2KDCwSj9VUQqd9iIfKYfc9SS7O7xfsm1N
         7QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709296594; x=1709901394;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46QQdgNfVCnY0kDCTnTRBIKamFFvFvZLtfXf6iIr6kA=;
        b=hLf0ERqnYfatnAwx7TKDEFcfAv5pTk1/Os0tEFI1HrlxZJrxudbhg0Aow+sprcg+pN
         vKzj1/w4OB6uiyD19SwLrSiv5IHVzyiI3vqM8mGOv5/gqpyDo8XFD+X5C1fXJf9ggCzg
         GKaM0vzdDNDZ2Xc5CoyI+2aPBm6BwB+70v8FUZfCKox1pvnLZfz/j/6ryF6SU/XXci34
         X329Zfu+922IJclNj1RTf6kkR0VieW9BmvX3PuVwhGRV6BSDaLw0i1E5jLF5ns/NN6g6
         dz62sZApDK5lD9GVEPa3ndNyolPVSV8xnjZBcfMRhOGe85Jo+tir9EXghyjC3VulDCpG
         +xQA==
X-Gm-Message-State: AOJu0YzkgfsMEvHhiEntU2JcKreuB0Qo8LUk5Eky7xwZ8XKw2WQFIziW
	qAwSkaNMaJh5qlCRHB7qOWaa+/08IcLU1EQgPKmKFTxjfNyJEKk/05LPnrKMDQjP4qbGT1hlrBr
	k6TseW2pSrVBGL6QSUYnUkxL/vJ/dmsOa3Q==
X-Google-Smtp-Source: AGHT+IG5S/kZXX5IeZ92K4sbaoqWk+raWhVwmQJUhLMZ/fbCcM2Zn5XXAWo4pbSLZAUKvM3ZWf4J9dXgNBIQ0fKVnBM=
X-Received: by 2002:a4a:3557:0:b0:5a1:82c:be8b with SMTP id
 w23-20020a4a3557000000b005a1082cbe8bmr543161oog.0.1709296594147; Fri, 01 Mar
 2024 04:36:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Jayalakshmi Manunath Bhat ," <bhat.jayalakshmi@gmail.com>
Date: Fri, 1 Mar 2024 18:05:57 +0530
Message-ID: <CALq8RvJDQ9U4x_Beew0jGQqSQtm3TGXh9m5aSvrzPZeft0h0Kg@mail.gmail.com>
Subject: https over ESP is not working in kernel version 5.10.199
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi All.

On our device I am able to establish IPsec IKEv1 rules successfully on
kernel version 5.10.199. Ping, Telnet, http (port 80) etc works fine.
However when I am trying to https to device, operation fails and error
is in xfrm_input.c and error is
if (nexthdr == -EBADMSG), nexthdr is EBADMSG and the packet is
dropped. I do not understand why https fails.

Have any of you come across this error?

Regards,
Jaya
