From: Gigi W <gigitekwork@gmail.com>
Subject: Re: Integrity checking fails with Atmel SHA hw
	accelerator enabled
Date: Mon, 26 Feb 2018 08:31:31 +0200
Message-ID: <CAAm399SksqBEReTYP0Oc7gMn5Xxa_Aiirem8Yc34qOGk9_TL4A@mail.gmail.com>
References: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
	<CAOtvUMdwtUg4dRq6=bcRjvtuJByQPUhJLGrLvF-Dxxt3fc1iJw@mail.gmail.com>
	<CAAm399Tvq7nLs=LUb+u+oob1r37Nsstz6vm-=WGF+wQ+6189UA@mail.gmail.com>
	<CAOtvUMdgWwHuHwh-vcVkW5gUR5ukZfCMOGhVv1civkynj9oX=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1805525051288673233=="
Cc: device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOtvUMdgWwHuHwh-vcVkW5gUR5ukZfCMOGhVv1civkynj9oX=A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

--===============1805525051288673233==
Content-Type: multipart/alternative; boundary="001a113f6ad82be368056617a934"

--001a113f6ad82be368056617a934
Content-Type: text/plain; charset="UTF-8"

Thanks again for feedback !
Yes, I can do some additional tests in order to isolate the problem.
I'm not that familiar with the code responsible for this so I'll ask for
your help with a patch. It will be quicker that way.

Best regards
Mircea


On Sat, Feb 24, 2018 at 10:59 AM, Gilad Ben-Yossef <gilad@benyossef.com>
wrote:

> Hi,
>
> I'm adding the linux crypto mailing list because it seems relevant.
>
>
> On Fri, Feb 23, 2018 at 2:25 PM, Gigi W <gigitekwork@gmail.com> wrote:
> > Thanks for the input!
> >
> > See below
> >
> >
> > On Fri, Feb 23, 2018 at 10:53 AM Gilad Ben-Yossef <gilad@benyossef.com>
> > wrote:
> >>
> >> On Fri, Feb 23, 2018 at 10:30 AM, Gigi W <gigitekwork@gmail.com> wrote:
> >> > Hi
> >> >
> >> > I'm having some trouble using dm-verity for a squashfs root file
> system
> >> > that
> >> > seems to be related to the
> >> > Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA
> >> >
> >> > Some info about my setup:
> >> > * I'm using a board with a SAMA5D4 CPU.
> >> > * I'm using Yocto rocko for building an image for that device.
> >> >
> >> > The idea is that Using the 4.14.14 Kernel, Integrity checking using
> >> > Kernel
> >> > crypto fails with Atmel SHA hw accelerator enabled in kernel.
> >> > By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=n`, and using the
> software
> >> > sha256 algo, integrity checking works as expected.
> >> > This is my kernel config [3]
> >> >
> >> > Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled,
> everything
> >> > was
> >> > ok.
> >> >
> >> > This is what triggers the error during verified boot:
> >> >
> >> > status=`veritysetup create vroot $root_dev $verity_dev --hash-offset
> >> > $hashoffset $root_hash`
> >> >
> >> >     mount /dev/mapper/vroot /mnt/
> >> >     mount_ok=`cat /proc/mounts | grep mnt`
> >> >     if [ -z "$mount_ok" ] ; then
> >> >         echo "Failed to mount $root_dev on mnt/"
> >> >     else
> >> >         echo "Switch rootfs"
> >> >         exec switch_root -c /dev/console /mnt /sbin/init
> >> >     fi
> >> >
> >> > The mount operation fails:
> >> >
> >> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> >> > EXT4-fs (dm-0): unable to read superblock
> >> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> >> > EXT4-fs (dm-0): unable to read superblock
> >> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> >> > EXT4-fs (dm-0): unable to read superblock
> >> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> >> > SQUASHFS error: squashfs_read_data failed to read block 0x0
> >> > squashfs: SQUASHFS error: unable to read squashfs_super_block
> >> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> >> > FAT-fs (dm-0): unable to read boot sector
> >> > mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error
> >> > Failed to mount /dev/mmcblk0p4 on mnt/
> >> > reboot: Restarting system
> >> > Reboot failed -- System halted
> >> >
> >> > Using veritysetup to verify the integrity against the hashes is
> >> > successful,
> >> > as it's not using the kernel for that ...
> >> >
> >> >
> >> > So it looks like it something changed from 4.8.4 to 4.14.14.
> >>
> >> If I am not mistaken the Atmel SHA hw accelerator is an async (read:
> >> off CPU) crypto accelerator.
> >>  Up until 4.12 (I think...) DM-Verity did not use async crypto
> >> accelerators (even if present and have high
> >> priority). I've changed this is commit d1ac3ff008fb ("dm verity:
> >> switch to using asynchronous hash crypto API").
> >
> >
> > This would explain some things, like the same speeds while reading from a
> > verity device, having the CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then
> > disabled, on the 4.8.4 kernel -> it was always using the sync API.
> >
> >>
> >>
> >> Is it possible that whatever issue you are seeing has always been
> >> there and when DM-Verity started using
> >> async. accelerators it was only exposed?
> >
> >
> > It looks like it.
> >
> > From my understandings + tests described above, Atmel SHA hw accelerator
> > works correctly - output hashes are ok, dm-verity with other async crypto
> > accelerators is working ok,
> > but dm-verity + Atmel SHA hw accelerator don't play nice together.
> >
> > I couldn't find anyone else complaining about this.
> >
>
> I agree that that the possibility that there is something wrong in the
> Atmel SHA accelerator is one possible direction.
> The other one is that there is something wrong in DM-Verity that only
> manifests under certain conditions when working with async crypto HW
> providers.
> I don't think it is the case, because I tested DM-Verity after my
> changes with the CryptoCell async HW provider and did not get any
> other bug reports, but I'd like to be sure.
>
> Can you do a little experiment? add debug printk to show the data
> being hashed, the hash produced by atmel and the expected
> pre-calculated hash.
>
> If the theory that there is something wrong with atmel accelerator, we
> can calculate the hash on the data with other means (software) and
> should get a different hash.
>
> If you are having trouble adding the printk's in the right place let
> me know and I'll create a patch for you to test.
>
> Cheers,
> Gilad
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru
>

--001a113f6ad82be368056617a934
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Thanks again for feedback !<br></div>Y=
es, I can do some additional tests in order to isolate the problem.<br></di=
v>I&#39;m not that familiar with the code responsible for this so I&#39;ll =
ask for your help with a patch. It will be quicker that way.<br><br></div>B=
est regards<br></div>Mircea<br><br></div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">On Sat, Feb 24, 2018 at 10:59 AM, Gilad Ben-Yossef =
<span dir=3D"ltr">&lt;<a href=3D"mailto:gilad@benyossef.com" target=3D"_bla=
nk">gilad@benyossef.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">Hi,<br>
<br>
I&#39;m adding the linux crypto mailing list because it seems relevant.<br>
<div><div class=3D"h5"><br>
<br>
On Fri, Feb 23, 2018 at 2:25 PM, Gigi W &lt;<a href=3D"mailto:gigitekwork@g=
mail.com">gigitekwork@gmail.com</a>&gt; wrote:<br>
&gt; Thanks for the input!<br>
&gt;<br>
&gt; See below<br>
&gt;<br>
&gt;<br>
&gt; On Fri, Feb 23, 2018 at 10:53 AM Gilad Ben-Yossef &lt;<a href=3D"mailt=
o:gilad@benyossef.com">gilad@benyossef.com</a>&gt;<br>
&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt; On Fri, Feb 23, 2018 at 10:30 AM, Gigi W &lt;<a href=3D"mailto:gig=
itekwork@gmail.com">gigitekwork@gmail.com</a>&gt; wrote:<br>
&gt;&gt; &gt; Hi<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I&#39;m having some trouble using dm-verity for a squashfs ro=
ot file system<br>
&gt;&gt; &gt; that<br>
&gt;&gt; &gt; seems to be related to the<br>
&gt;&gt; &gt; Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATM=
EL_SHA<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Some info about my setup:<br>
&gt;&gt; &gt; * I&#39;m using a board with a SAMA5D4 CPU.<br>
&gt;&gt; &gt; * I&#39;m using Yocto rocko for building an image for that de=
vice.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; The idea is that Using the 4.14.14 Kernel, Integrity checking=
 using<br>
&gt;&gt; &gt; Kernel<br>
&gt;&gt; &gt; crypto fails with Atmel SHA hw accelerator enabled in kernel.=
<br>
&gt;&gt; &gt; By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=3D<wbr>n`, and =
using the software<br>
&gt;&gt; &gt; sha256 algo, integrity checking works as expected.<br>
&gt;&gt; &gt; This is my kernel config [3]<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, =
everything<br>
&gt;&gt; &gt; was<br>
&gt;&gt; &gt; ok.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; This is what triggers the error during verified boot:<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; status=3D`veritysetup create vroot $root_dev $verity_dev --ha=
sh-offset<br>
&gt;&gt; &gt; $hashoffset $root_hash`<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0mount /dev/mapper/vroot /mnt/<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0mount_ok=3D`cat /proc/mounts | grep mnt`<b=
r>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0if [ -z &quot;$mount_ok&quot; ] ; then<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;Failed to mount $=
root_dev on mnt/&quot;<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0else<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;Switch rootfs&quo=
t;<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exec switch_root -c /dev/con=
sole /mnt /sbin/init<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0fi<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; The mount operation fails:<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<b=
r>
&gt;&gt; &gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt;&gt; &gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<b=
r>
&gt;&gt; &gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt;&gt; &gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<b=
r>
&gt;&gt; &gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt;&gt; &gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<b=
r>
&gt;&gt; &gt; SQUASHFS error: squashfs_read_data failed to read block 0x0<b=
r>
&gt;&gt; &gt; squashfs: SQUASHFS error: unable to read squashfs_super_block=
<br>
&gt;&gt; &gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<b=
r>
&gt;&gt; &gt; FAT-fs (dm-0): unable to read boot sector<br>
&gt;&gt; &gt; mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/outp=
ut error<br>
&gt;&gt; &gt; Failed to mount /dev/mmcblk0p4 on mnt/<br>
&gt;&gt; &gt; reboot: Restarting system<br>
&gt;&gt; &gt; Reboot failed -- System halted<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Using veritysetup to verify the integrity against the hashes =
is<br>
&gt;&gt; &gt; successful,<br>
&gt;&gt; &gt; as it&#39;s not using the kernel for that ...<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; So it looks like it something changed from 4.8.4 to 4.14.14.<=
br>
&gt;&gt;<br>
&gt;&gt; If I am not mistaken the Atmel SHA hw accelerator is an async (rea=
d:<br>
&gt;&gt; off CPU) crypto accelerator.<br>
&gt;&gt;=C2=A0 Up until 4.12 (I think...) DM-Verity did not use async crypt=
o<br>
&gt;&gt; accelerators (even if present and have high<br>
&gt;&gt; priority). I&#39;ve changed this is commit d1ac3ff008fb (&quot;dm =
verity:<br>
&gt;&gt; switch to using asynchronous hash crypto API&quot;).<br>
&gt;<br>
&gt;<br>
&gt; This would explain some things, like the same speeds while reading fro=
m a<br>
&gt; verity device, having the CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then=
<br>
&gt; disabled, on the 4.8.4 kernel -&gt; it was always using the sync API.<=
br>
&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Is it possible that whatever issue you are seeing has always been<=
br>
&gt;&gt; there and when DM-Verity started using<br>
&gt;&gt; async. accelerators it was only exposed?<br>
&gt;<br>
&gt;<br>
&gt; It looks like it.<br>
&gt;<br>
&gt; From my understandings + tests described above, Atmel SHA hw accelerat=
or<br>
&gt; works correctly - output hashes are ok, dm-verity with other async cry=
pto<br>
&gt; accelerators is working ok,<br>
&gt; but dm-verity + Atmel SHA hw accelerator don&#39;t play nice together.=
<br>
&gt;<br>
&gt; I couldn&#39;t find anyone else complaining about this.<br>
&gt;<br>
<br>
</div></div>I agree that that the possibility that there is something wrong=
 in the<br>
Atmel SHA accelerator is one possible direction.<br>
The other one is that there is something wrong in DM-Verity that only<br>
manifests under certain conditions when working with async crypto HW<br>
providers.<br>
I don&#39;t think it is the case, because I tested DM-Verity after my<br>
changes with the CryptoCell async HW provider and did not get any<br>
other bug reports, but I&#39;d like to be sure.<br>
<br>
Can you do a little experiment? add debug printk to show the data<br>
being hashed, the hash produced by atmel and the expected<br>
pre-calculated hash.<br>
<br>
If the theory that there is something wrong with atmel accelerator, we<br>
can calculate the hash on the data with other means (software) and<br>
should get a different hash.<br>
<br>
If you are having trouble adding the printk&#39;s in the right place let<br=
>
me know and I&#39;ll create a patch for you to test.<br>
<br>
Cheers,<br>
Gilad<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
Gilad Ben-Yossef<br>
Chief Coffee Drinker<br>
<br>
&quot;If you take a class in large-scale robotics, can you end up in a<br>
situation where the homework eats your dog?&quot;<br>
=C2=A0-- Jean-Baptiste Queru<br>
</div></div></blockquote></div><br></div>

--001a113f6ad82be368056617a934--


--===============1805525051288673233==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1805525051288673233==--
