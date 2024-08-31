Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF141531C0;
	Sat, 31 Aug 2024 08:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725094460; cv=none; b=aI/8IkyByAJrGwuYeRq6VZ9B5tEwfprUDlIW3fCwpxdS/uBSnr9Y64Qp0laWSoeQjZw7ss/kbUK8fJfxQmxt1b4os+57kREInbcqQOguKQIn4WtGRouU3klmEOs1Mx1Iidga7fGquIk4X5g6J8roavnmXdWO+sHfcbRQ0lYir7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725094460; c=relaxed/simple;
	bh=BCXHaE7OJDlB4tgitxbJMg23VXydDQugT53Pzm60vqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tiYlwm83hPsdPtV6MzjkjdiN2JQdwFTvfY5L5MUzkJRVTUEQ3XwzhjKlLG/6m5rEEMWUUObFb7uCIhsrptCdOmisHF+F2F7i5dctxYnbIlVgRxr/MAFYXSzWpgdgOxgVCABXhgQYktt49h3Sz9Qwpgdlcbr609QhwDDrMACoGYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4WwpjN4LNJz9sSN;
	Sat, 31 Aug 2024 10:54:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5wI910mZmxra; Sat, 31 Aug 2024 10:54:16 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4WwpjN3KgBz9sSK;
	Sat, 31 Aug 2024 10:54:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 5C9408B76C;
	Sat, 31 Aug 2024 10:54:16 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id dO7Fs0TtgoVO; Sat, 31 Aug 2024 10:54:16 +0200 (CEST)
Received: from [192.168.234.150] (unknown [192.168.234.150])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CCEFA8B764;
	Sat, 31 Aug 2024 10:54:15 +0200 (CEST)
Message-ID: <302f203a-088c-431f-beef-86b10ae9b284@csgroup.eu>
Date: Sat, 31 Aug 2024 10:54:14 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
To: Huacai Chen <chenhuacai@kernel.org>, Xi Ruoyao <xry111@xry111.site>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>, WANG Xuerui <kernel@xen0n.name>,
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
 Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20240829125656.19017-1-xry111@xry111.site>
 <CAAhV-H5Srpno_m+_dPS=Z-sdRrdXS3xEoG8tEaAB=8QqswTK9w@mail.gmail.com>
 <1bd7a61241f09331d27d8ad0df04726941c45f85.camel@xry111.site>
 <CAAhV-H6es9x3rA5ZeSMjqYLQsTU3h-_QOa2siA770pY7Ju8rRw@mail.gmail.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <CAAhV-H6es9x3rA5ZeSMjqYLQsTU3h-_QOa2siA770pY7Ju8rRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 31/08/2024 à 09:10, Huacai Chen a écrit :
> [Vous ne recevez pas souvent de courriers de chenhuacai@kernel.org. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Sat, Aug 31, 2024 at 2:40 PM Xi Ruoyao <xry111@xry111.site> wrote:
>>
>> On Thu, 2024-08-29 at 21:18 +0800, Huacai Chen wrote:
>>>> -obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o
>>>> +obj-vdso-y := elf.o vgetcpu.o vgettimeofday.o sigreturn.o vgetrandom.o \
>>>> +              vgetrandom-chacha.o
>>
>> Huacai: do you prefer to remove this line break as well, or Makefile
>> still has a line width limit?
> Also no limit, but Makefile is more or less different because there is
> no "statement" and doesn't affect our understanding.
> 
> So, line break is fine here (but for my own preference I like to keep
> sigreturn.o at last).

To avoid line break you can leave the first line unmodified and add:

obj-vdso-y += vgetrandom.o vgetrandom-chacha.o

Christophe
