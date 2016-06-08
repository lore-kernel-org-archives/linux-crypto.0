From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc] niagara2 cpu, opcodes not available message?
Date: Wed, 8 Jun 2016 21:27:21 +0300
Message-ID: <CADxRZqxhpKHS6mRcf01GNUTzDN4BEne337_CZJ_kD6XMrtzsNw@mail.gmail.com>
References: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: debian-sparc <debian-sparc@lists.debian.org>,
	linux-crypto@vger.kernel.org
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 8, 2016 at 8:30 PM, Anatoly Pugachev <matorola@gmail.com> wrote:
> Hello!
>
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
>
> Can we probably remove this functionality/messages from niagara2 cpus,
> if it does not support it anyway?

Wasn't clear at all, I mean can we please change pr_info in
arch/sparc/crypto/ to pr_debug in xx_sparc64_mod_init() functions?
Thanks.
