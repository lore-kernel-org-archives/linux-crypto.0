Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662AA15C0
	for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2024 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731865391; cv=none; b=dtl5UTp7ueMkSTz/UTscdZ01pTXKBseXN3NSKdxgPo85GCbHVxCqiyrNSvhxATcMURlgnFU+koWISQqEsCpqcxK5cPWPnMTU58n6WEmVjcnr4FKFHXzAFF4owWDYwCSq9sWNGTEV+pJwPrIAvEnL1qi6cWENNz9Xd1b9ggMmXW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731865391; c=relaxed/simple;
	bh=HdkrLS4N5IaGRCk7FkKfqIv1V3s5XNbrr9gl+DW2Mz4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ojbwHesu4MOs3XF8PI90TPPGRpm+2/A95VkHBCfpOnLTXt+XhKlSkK1KK1Yc8vjUnCOb6x4XTbKMUv1Ssj2f4fhIZQOZM5dGZb6QrT4YPhq+6AMb46LdZTHICDAlSk+67j0DuAybHLgRk+J0jqC7zPAm+rYw5owgwurzYUX5zek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QH85V8Ns; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QH85V8Ns"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-724455f40a0so2209668b3a.0
        for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2024 09:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731865390; x=1732470190; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HdkrLS4N5IaGRCk7FkKfqIv1V3s5XNbrr9gl+DW2Mz4=;
        b=QH85V8NsLPrZN9yAvS7obHz+XDKc5bOiZk467O+FwduLhQ3Vkzu7ddqBnXLxbi7hxG
         FTQvpqoyua2HhZENuAGOUG0N7zAohCLR05B3gLjIyItyu3xc8MJabN/4mD4vvCMSnQxH
         ruR9nWo66FXctJ0JqcTRfduOYbuj9T+lXCjJaaSGoHHcAOBOoKkEfKbKbGr6UZrNtA9d
         nTDOXdq64CVgOEBcGnEl/7VQPnHRrLWX3UZNurrNyA1QbXO3F321vSSWkiL5Sw0nkLPB
         llr8Koe1EQGBaQ4yOiVHroj0QE6kA/7+maKyq1atF1g2cYG7gE94X8n+7NgqDEQCZfFx
         ONNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731865390; x=1732470190;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HdkrLS4N5IaGRCk7FkKfqIv1V3s5XNbrr9gl+DW2Mz4=;
        b=uWjUq6Wm3sfmDJOe6G5CMntcioW4LvAvhlYsrK17Y9R6JGZpWJ8A/Ew4+uwcMR/RVU
         S+K6VytFCVHgh/u1RWEeMKsn0OH6ir/teq3RafOUl17J7NlYZrbKRDRJ6OcqZQrS+PW5
         xt2D30VMmXx/ddIIMT/5Df96DpmU4c6kZloYrPHfuhvevyFGaGQFOptw8ikmWYvsDVSA
         IVmR69lBuOPHDIcsKYnJcyXVB0OFrsG+RJm+y+2/scWslZ20xqXtXSQQE//jRImXdin4
         LQ6gYbiRVQsSoUn7EL8MrEnbfrNtCELgLNwEn+1hrXEkYAJCh2ir+sgfivS43Wg2ad6g
         /8jw==
X-Gm-Message-State: AOJu0YwCyODqrZi2vFbxYrB7cGIk8EW/VrV2TRxXHEudzobraKWLUbyf
	V2Pi7WNmLc+9DcVQoniygOn2SA4gL6eDZ72SK1K6KkTZku4nGWahCyK/3JxeF6KrJi8VbQkiHAe
	LzloBHqtoTVo0syIa5+cP/c9/5rs=
X-Google-Smtp-Source: AGHT+IFgW67xr2l6NkZim41KYSthUwev5XDwa/qLI8ZtKV0lLBv/sV8gCrQCw3IEoKO0Caa5JDk3vnpycemYADw80aY=
X-Received: by 2002:a05:6a00:3d47:b0:71e:4e2a:38bf with SMTP id
 d2e1a72fcca58-72476c752e2mr13746197b3a.18.1731865389657; Sun, 17 Nov 2024
 09:43:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jacobo Pantoja <jacobopantoja@gmail.com>
Date: Sun, 17 Nov 2024 18:42:57 +0100
Message-ID: <CAO18KQgWZ5ChFf3c+AgO9fneoaHhBEAOcfUmRFw80xLnE68qWg@mail.gmail.com>
Subject: CCP issue related to GPU pass-through?
To: mario.limonciello@amd.com
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mario / crypto mailing list:

I'm trying to pass-through my AMD 5600G's integrated CPU; I can do it
easily with Linux guest, but I'm being unable to do so with a Windows
11 guest (which is my end goal)

I've noted in my dmesg the following line:
"ccp: unable to access the device: you might be running a broken BIOS"

Tracing it a bit on the internet, I found a couple of fwupd commits
done by you stating that in some platforms this is expected (e.g.
0x1649) [1]
Comparing, in my motherboard I see that the Platform Security
Processor is 1022:15DF, being that last number in the same code you
applied the patch... but I cannot understand whether the ccp message
is expected on this platform (chipset is B450, if it adds info) or
not; and if this could be related to the pass-through problems.

Any hints would be more than welcome

Best regards
JPantoja

[1]: https://lore.kernel.org/linux-crypto/56d92baa-d05a-9b02-0195-7627187fdde1@amd.com/T/#t
