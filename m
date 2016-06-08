From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc] niagara2 cpu, opcodes not available message?
Date: Wed, 8 Jun 2016 20:57:13 +0300
Message-ID: <CADxRZqwzr0KvPKVtNc6B7+_u8WhMaJq_u5C_xtQ5Ko2NULLkzQ@mail.gmail.com>
References: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a1145a35a0fbfbb0534c80933
Cc: linux-crypto@vger.kernel.org, debian-sparc <debian-sparc@lists.debian.org>
To: sparclinux@vger.kernel.org
Return-path: <bounce-debian-sparc=debian-sparc=m.gmane.org@lists.debian.org>
In-Reply-To: <CADxRZqwr9=9ZsrFR_8iC+f1Z=hSPi7Saj3uxB2=YmH42sVf6pQ@mail.gmail.com>
Resent-Message-ID: <2awk3kqFtTL.A.X4B.IyFWXB@bendel>
List-URL: <https://lists.debian.org/debian-sparc/>
List-Post: <mailto:debian-sparc@lists.debian.org>
List-Help: <mailto:debian-sparc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-sparc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-sparc-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/CADxRZqwzr0KvPKVtNc6B7+_u8WhMaJq_u5C_xtQ5Ko2NULLkzQ@mail.gmail.com
List-Id: linux-crypto.vger.kernel.org

--001a1145a35a0fbfbb0534c80933
Content-Type: text/plain; charset=UTF-8

On Jun 8, 2016 8:30 PM, "Anatoly Pugachev" <matorola@gmail.com> wrote:
>
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

--001a1145a35a0fbfbb0534c80933
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">On Jun 8, 2016 8:30 PM, &quot;Anatoly Pugachev&quot; &lt;<a =
href=3D"mailto:matorola@gmail.com">matorola@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hello!<br>
&gt;<br>
&gt; Can someone please tell, why do we get a bunch of the following<br>
&gt; messages on niagara2 cpu hardware (SPARC Enterprise T5120, T5220,<br>
&gt; T5140, and T5240 servers)<br>
&gt;<br>
&gt; Asking, because I see the following lines on kernel boot (removing<br>
&gt; first field boot time stamp in cut):<br>
&gt;<br>
&gt; mator@nvg5120:~/linux-sparc-boot-logs/t5120$ grep opcode<br>
&gt; dmesg-4.7.0-rc2+.log=C2=A0 | cut -f2- -d&#39; &#39; | sort | uniq -c<b=
r>
&gt; =C2=A0 =C2=A0 =C2=A0 4 aes_sparc64: sparc64 aes opcodes not available.=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 7 camellia_sparc64: sparc64 camellia opcodes not =
available.<br>
&gt; =C2=A0 =C2=A0 =C2=A037 crc32c_sparc64: sparc64 crc32c opcode not avail=
able.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 5 des_sparc64: sparc64 des opcodes not available.=
<br>
&gt; =C2=A0 =C2=A0 =C2=A0 4 md5_sparc64: sparc64 md5 opcode not available.<=
br>
&gt; =C2=A0 =C2=A0 =C2=A0 1 sha1_sparc64: sparc64 sha1 opcode not available=
.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 2 sha256_sparc64: sparc64 sha256 opcode not avail=
able.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 3 sha512_sparc64: sparc64 sha512 opcode not avail=
able.<br>
&gt;<br>
&gt; Can we probably remove this functionality/messages from niagara2 cpus,=
<br>
&gt; if it does not support it anyway?</p>
<p dir=3D"ltr">Wasn&#39;t clear at all, I mean can we please change pr_info=
 in arch/sparc/crypto/ to pr_debug in xx_sparc64_mod_init() functions?</p>

--001a1145a35a0fbfbb0534c80933--
