From: David Miller <davem@davemloft.net>
Subject: Re: [sparc] niagara2 cpu, opcodes not available message?
Date: Wed, 08 Jun 2016 11:33:48 -0700 (PDT)
Message-ID: <20160608.113348.1609018295943976971.davem@davemloft.net>
References: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, debian-sparc@lists.debian.org,
	linux-crypto@vger.kernel.org
To: matorola@gmail.com
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Anatoly Pugachev <matorola@gmail.com>
Date: Wed, 8 Jun 2016 20:30:40 +0300

> Can someone please tell, why do we get a bunch of the following
> messages on niagara2 cpu hardware (SPARC Enterprise T5120, T5220,
> T5140, and T5240 servers)
> 
> Asking, because I see the following lines on kernel boot (removing
> first field boot time stamp in cut):
> 
> mator@nvg5120:~/linux-sparc-boot-logs/t5120$ grep opcode
> dmesg-4.7.0-rc2+.log  | cut -f2- -d' ' | sort | uniq -c
>       4 aes_sparc64: sparc64 aes opcodes not available.
>       7 camellia_sparc64: sparc64 camellia opcodes not available.
>      37 crc32c_sparc64: sparc64 crc32c opcode not available.
>       5 des_sparc64: sparc64 des opcodes not available.
>       4 md5_sparc64: sparc64 md5 opcode not available.
>       1 sha1_sparc64: sparc64 sha1 opcode not available.
>       2 sha256_sparc64: sparc64 sha256 opcode not available.
>       3 sha512_sparc64: sparc64 sha512 opcode not available.

Because the drivers unconditionally try to load, check the CPU capabilites
and emit the log message if the cpu caps aren't present.

I don't see what the problem is, everying is working as designed.
