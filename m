Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C36B38388
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2024 04:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706589306; cv=none; b=jgtfYUU58dq9ZoS7u8LpFTyTTIDNKlJGKz1hGHj6wuXUe4mnKr1Thrn/8oHvQWI2hQ5RWRR9vfcOQoCXUIDLnV3nPhLhuT6R3X+feiOj9sSkACTRDEQamP3Nv/Mr52Dvn/MaNHZ8tFHuxkgouxqNVXz0vGQbqxIHhlhZJrMc6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706589306; c=relaxed/simple;
	bh=LFkzXBPYkqsgDKMkgmPiWdwagQDjIZa3uJZcMBgvZqk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MYE1/MgfMWfMCxb+LKOor/LNsZS4PEprtiE2QXanMPruYvguL62czHMXsE7XkzeM6VffloX58o5opfxc3WqWheh1WVZvQxjvlCF1bXlJWE0JUvpxnkMJwWlpOxIY5p/I2OLhLZOL861hVe09ha7RLdGHWETC5nRD+fpbkfRxgcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WUogjmuM; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WUogjmuM"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-59883168a83so1172950eaf.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jan 2024 20:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706589304; x=1707194104; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LFkzXBPYkqsgDKMkgmPiWdwagQDjIZa3uJZcMBgvZqk=;
        b=WUogjmuMibJ/H9Z479RsRbQFaWWuTc6c0oGCZuOCjQ875GnOVLNAjxkXu0k83JFnDv
         096IhFGY7djCqvBuKUDGinJs8jCCoX+tc3qx1R+N2Y5bfbp9mOFOdKEFoKLOaEH83a9P
         LUyVMeGjAgakNgjQifIotDd2NgOmgFPpKMhScdiCWFyEsKDZ77pzXKyFGNl5YLuFeYlp
         752RgHhvVNyuMUJ9hEk/BkjZPcI5CB0glU7gHs3xYMJY03zDuyLdfV681EBEvRh5WQVR
         FKE7SMLlXlD+Q2lxxaMDuV7GqAjNn8eGqwm+etlvyIpWeZVnXm/0iKoFcAbDY6NQ9RTY
         4RLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706589304; x=1707194104;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LFkzXBPYkqsgDKMkgmPiWdwagQDjIZa3uJZcMBgvZqk=;
        b=N2JkM7wEM5nxOcq6hehaJ1NUOJuWNlhsZ9rsR2al+88yOxRvfHdnocC+EpTpTxTSMY
         XPMpT6pbE91bbt5/c7EInqJ3xu5qoE8GEIpXA0QMA0UGjxb+K1/a6qArcNQCG4xN0EQd
         uf6tI9bGKyc2+VHGG6SHNcYDwJcoQ6AQPTxSdDTiHm/E8+3R0hicFpHelnGFhxhLMzRI
         jHpl7kcE8ZVcltpvT1qA7P8wx1CBSEGLWTBN2vYDG1MObXTM6OTJQcp6/0fAfexY7so7
         lOyODh6B/KMJa6MgeTZyBNL4fJo5BC/ioZa41WTvxuyGWzlbS4/nIniBg6yMf7LI/U+Y
         ul4A==
X-Gm-Message-State: AOJu0YztQRaEEhFapweX3f6MkTCFPZdbdF2HTaHx/Nj/nM1QXT/Y3dJj
	4taMLpOVmKV9bLmqcuanto+j88av269SlJbi4yvu8MYqaTSPYDIXGMJY8nC59aQjgPWd8Funuwh
	SQ5eVQfhqRFSxFwCITX2iOjATwCEXJqG5Iw==
X-Google-Smtp-Source: AGHT+IGYOitfC0RZwB/9DOJ0tVjziO4PPSdf/DypZluYOqlKzARMovKgRsbVnaAAd30hG8GLrIsTBb4PY7Aki1lHX5U=
X-Received: by 2002:a05:6820:1503:b0:59a:15d2:ba0d with SMTP id
 ay3-20020a056820150300b0059a15d2ba0dmr4661501oob.2.1706589304174; Mon, 29 Jan
 2024 20:35:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Jayalakshmi Manunath Bhat ," <bhat.jayalakshmi@gmail.com>
Date: Tue, 30 Jan 2024 10:03:39 +0530
Message-ID: <CALq8RvL79sUBcXJNC4qHT=eYfYRQL4eB2JcMRXW2e6sFyf2Lsw@mail.gmail.com>
Subject: Help needed to understand the mailing group for networking user questions
To: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

I wanted to know the mailing group to post networking user questions.
Can anyone tell me what is the appropriate mailing group?
Thanks and Regards,
Jayalakshmi
