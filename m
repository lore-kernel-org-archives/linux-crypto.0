From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: Integrity checking fails with Atmel SHA hw
	accelerator enabled
Date: Sat, 24 Feb 2018 10:59:46 +0200
Message-ID: <CAOtvUMdgWwHuHwh-vcVkW5gUR5ukZfCMOGhVv1civkynj9oX=A@mail.gmail.com>
References: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
	<CAOtvUMdwtUg4dRq6=bcRjvtuJByQPUhJLGrLvF-Dxxt3fc1iJw@mail.gmail.com>
	<CAAm399Tvq7nLs=LUb+u+oob1r37Nsstz6vm-=WGF+wQ+6189UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gigi W <gigitekwork@gmail.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAm399Tvq7nLs=LUb+u+oob1r37Nsstz6vm-=WGF+wQ+6189UA@mail.gmail.com>
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

Hi,

I'm adding the linux crypto mailing list because it seems relevant.


On Fri, Feb 23, 2018 at 2:25 PM, Gigi W <gigitekwork@gmail.com> wrote:
> Thanks for the input!
>
> See below
>
>
> On Fri, Feb 23, 2018 at 10:53 AM Gilad Ben-Yossef <gilad@benyossef.com>
> wrote:
>>
>> On Fri, Feb 23, 2018 at 10:30 AM, Gigi W <gigitekwork@gmail.com> wrote:
>> > Hi
>> >
>> > I'm having some trouble using dm-verity for a squashfs root file system
>> > that
>> > seems to be related to the
>> > Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA
>> >
>> > Some info about my setup:
>> > * I'm using a board with a SAMA5D4 CPU.
>> > * I'm using Yocto rocko for building an image for that device.
>> >
>> > The idea is that Using the 4.14.14 Kernel, Integrity checking using
>> > Kernel
>> > crypto fails with Atmel SHA hw accelerator enabled in kernel.
>> > By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=n`, and using the software
>> > sha256 algo, integrity checking works as expected.
>> > This is my kernel config [3]
>> >
>> > Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, everything
>> > was
>> > ok.
>> >
>> > This is what triggers the error during verified boot:
>> >
>> > status=`veritysetup create vroot $root_dev $verity_dev --hash-offset
>> > $hashoffset $root_hash`
>> >
>> >     mount /dev/mapper/vroot /mnt/
>> >     mount_ok=`cat /proc/mounts | grep mnt`
>> >     if [ -z "$mount_ok" ] ; then
>> >         echo "Failed to mount $root_dev on mnt/"
>> >     else
>> >         echo "Switch rootfs"
>> >         exec switch_root -c /dev/console /mnt /sbin/init
>> >     fi
>> >
>> > The mount operation fails:
>> >
>> > device-mapper: verity: 179:4: metadata block 2 is corrupted
>> > EXT4-fs (dm-0): unable to read superblock
>> > device-mapper: verity: 179:4: metadata block 2 is corrupted
>> > EXT4-fs (dm-0): unable to read superblock
>> > device-mapper: verity: 179:4: metadata block 2 is corrupted
>> > EXT4-fs (dm-0): unable to read superblock
>> > device-mapper: verity: 179:4: metadata block 2 is corrupted
>> > SQUASHFS error: squashfs_read_data failed to read block 0x0
>> > squashfs: SQUASHFS error: unable to read squashfs_super_block
>> > device-mapper: verity: 179:4: metadata block 2 is corrupted
>> > FAT-fs (dm-0): unable to read boot sector
>> > mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error
>> > Failed to mount /dev/mmcblk0p4 on mnt/
>> > reboot: Restarting system
>> > Reboot failed -- System halted
>> >
>> > Using veritysetup to verify the integrity against the hashes is
>> > successful,
>> > as it's not using the kernel for that ...
>> >
>> >
>> > So it looks like it something changed from 4.8.4 to 4.14.14.
>>
>> If I am not mistaken the Atmel SHA hw accelerator is an async (read:
>> off CPU) crypto accelerator.
>>  Up until 4.12 (I think...) DM-Verity did not use async crypto
>> accelerators (even if present and have high
>> priority). I've changed this is commit d1ac3ff008fb ("dm verity:
>> switch to using asynchronous hash crypto API").
>
>
> This would explain some things, like the same speeds while reading from a
> verity device, having the CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then
> disabled, on the 4.8.4 kernel -> it was always using the sync API.
>
>>
>>
>> Is it possible that whatever issue you are seeing has always been
>> there and when DM-Verity started using
>> async. accelerators it was only exposed?
>
>
> It looks like it.
>
> From my understandings + tests described above, Atmel SHA hw accelerator
> works correctly - output hashes are ok, dm-verity with other async crypto
> accelerators is working ok,
> but dm-verity + Atmel SHA hw accelerator don't play nice together.
>
> I couldn't find anyone else complaining about this.
>

I agree that that the possibility that there is something wrong in the
Atmel SHA accelerator is one possible direction.
The other one is that there is something wrong in DM-Verity that only
manifests under certain conditions when working with async crypto HW
providers.
I don't think it is the case, because I tested DM-Verity after my
changes with the CryptoCell async HW provider and did not get any
other bug reports, but I'd like to be sure.

Can you do a little experiment? add debug printk to show the data
being hashed, the hash produced by atmel and the expected
pre-calculated hash.

If the theory that there is something wrong with atmel accelerator, we
can calculate the hash on the data with other means (software) and
should get a different hash.

If you are having trouble adding the printk's in the right place let
me know and I'll create a patch for you to test.

Cheers,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
