Received: from hatto.meta.co.jp (hatto.meta.co.jp [202.23.200.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF73E6FB9
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2024 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=202.23.200.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718067790; cv=pass; b=l/XrrlEAoYC7B8xam4CI5Zn5RzvtpkYaoeJT545wpIIcKUEkAQ9r1lrRXxcr6ftShL+JUcZVrAeXtgxQu7vgfyVth55UwMcECVDwvyUzaSA5o4U45UTPTL+KYIB90rzgN8aUuZvqYb/E7uq+lCLCq8PEpXDYbdbyzDffH1f2U7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718067790; c=relaxed/simple;
	bh=9EGfTZopiGgQAhODKHxelZlIc8fLUWSDWo1sv+RKg1U=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=R/3UdiHkE1eJOg+NVy/F4+2T+C8WzA/S+YfQV0etsU/fLhEvcnm8aJpEjYleF/33T1OU9XZZwY8LQI9i6LgiE/1aUDDhU9T1BHgxbtiVRPkD8/JM/DtV0eP2lJsMY5eRcEQwvZA4Ml2bfjiJDYtwh4PKfEQlCwWyinP/5UEVpkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ex.meta.co.jp; spf=pass smtp.mailfrom=ex.meta.co.jp; dkim=pass (1024-bit key) header.d=ex.meta.co.jp header.i=@ex.meta.co.jp header.b=skCIYb1j; arc=pass smtp.client-ip=202.23.200.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ex.meta.co.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ex.meta.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ex.meta.co.jp header.i=@ex.meta.co.jp header.b="skCIYb1j"
Received: from ss.meta.co.jp (ss.meta.co.jp [202.23.200.22])
	by hatto.meta.co.jp (Postfix) with ESMTP id E4AEA638BD
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2024 10:03:03 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ex.meta.co.jp;
	s=24012502; t=1718067783;
	bh=9EGfTZopiGgQAhODKHxelZlIc8fLUWSDWo1sv+RKg1U=;
	h=Date:To:From:Subject:From;
	b=skCIYb1jiOkNO7HpYKhnGYQbNjZwrl8EhN1aPaLSdkcKAr/7EdrD9Jv333I08aRlC
	 Fshh5BAgSPFYVmHgy4ttJnpNZACZMVs2hHJO7rWclZoptGor0RB4dFJOFGWwzg5Mbx
	 lUo3pnnMOGhByh08BuWun6LYKwLfMfcMnVOyQ2mg=
Received: from unknown (HELO poppo.mtlan.meta.co.jp) (192.168.100.46)
	by 202.23.200.22 with ESMTP; 11 Jun 2024 10:02:53 +0900
Received: from private
Authentication-Results: poppo.mtlan.meta.co.jp; arc=none smtp.remote-ip=10.2.41.27
ARC-Seal: i=1; a=rsa-sha256; d=meta.co.jp; s=24012501; t=1718067773; cv=none;
	b=A+Ca1sSua5MIw7XjVxMOhj3wSr6OoWjngRiExkNVOxGsd/n6d/3eTyTFaRiTtg0DhbflZk8KX8kEjHonv4VlJ+KJT/TyLDEKj8t4pLJKkJRMR9/d0WNCjpdFsCtxq1152tk7E6vXRpvdK2Ie4ZG9gRVu6nu13Xbh5GfgM/iMlUU=
ARC-Message-Signature: i=1; a=rsa-sha256; d=meta.co.jp; s=24012501;
	t=1718067773; c=relaxed/relaxed;
	bh=9EGfTZopiGgQAhODKHxelZlIc8fLUWSDWo1sv+RKg1U=;
	h=Message-ID:Date:MIME-Version:To:From:Subject; b=IgeWVFq9Jje+JGVHbItYBZ82NYau7mrcSDG0cgSVo6LAgdGmqy51XLVcW9tlOYKP0pG9A3Bh/m3/9KE9bjkImHKzobLnBPWwsaO+bilj2Iiy5e2dKFaE+Ah4XUF8zG97aKxj1s58I5JdCEsg5Yi3eJDpajB2eFwkKHY/HUulG1E=
ARC-Authentication-Results: i=1; poppo.mtlan.meta.co.jp
Message-ID: <6982dc10-a1f6-4951-9e8a-551a6d1fb517@ex.meta.co.jp>
Date: Tue, 11 Jun 2024 10:02:48 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-crypto@vger.kernel.org
Content-Language: en-US
From: Shinichiro Soeno <soeno.shinichiro@ex.meta.co.jp>
Subject: subscribe linux-crypto
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

subscribe linux-crypto

