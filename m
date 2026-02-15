Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4DA246BCD
	for <linux-crypto@vger.kernel.org>; Sun, 15 Feb 2026 21:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771189801; cv=pass; b=Oc85LI6pofCvolzbLSyTmc+xADeWcd7HKU28dWRQsnREuglZDj46eMB1u74nc4SbjCCiwfxq5ojFAIoTkivG2ktREEWeRHzGjVn8aEuntOt4o8WrFAsMDpI+Yx3butEb3sRDsiiGf4uDVMNC9T6FsrdSTfd3BV+pum9Q4gxRMrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771189801; c=relaxed/simple;
	bh=s+saamuLFlVf/0I9W1RYsvIqOOs2vJ1C7kourgd9C94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cKIdJGgtcaj++J4FGh2goOb3/PQgBBCd2Axyq1e8X1Ka3Mjl1huQBJV/jHC3+XEUl+0LjbyhNTcG9h3dfThuuK3kHqgxC4PP6fRKyRQ0jx1htY1rTj+eQGMB495immBoWU1mhvp3Ie76WAEiuiqbJ74NfZ4ye26RjdkWLqkKGVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QDfJiTXr; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QDfJiTXr"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-649d4cdb22cso269808d50.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Feb 2026 13:09:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771189798; cv=none;
        d=google.com; s=arc-20240605;
        b=lPpDrkixvJHMG6PBeStLQhdJkgf7Di5QumJi2IxL8JiAs7uAvQJQjhlTZW7zY/JTH6
         FV95LCAk8sgGj3STm9bS9GrpnIbKZ2jzzcRgB2Sx1g9BGtfn18nlLljQ9RTobsLHDOsW
         2MyIxyED1to70yiBv5FwDw33wPKCO7nwAjhYso4QbKqlJvaPd7QBtSwGkhEPlonPLPv8
         neumylmXjrRGOuYs4hCaWn/oSwL8b904xmFQjkfk8ESBOD6sJvaGlPIGNNWCTmheO1rG
         2W8nLTk4DbU+MA1UKY9oJyP4xKNu6ABcjD2rsgwTLPzgtf5eYZFIuC2NnpuTaZrgjrB/
         w4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8/cusOaB1RRkk5o1Oqtx1KMkhaZ63LZzGMA+5vMDafw=;
        fh=tty1Y/AKV3gm60oObOomvFywHC4ndzr9AaXUHgi90vA=;
        b=LV+PHLkWvedS/lWA/1ZXsfK0932V6sIx4N1AM5TpeFlpEKZ65FjPhgSVsSvynoUFe5
         BJlaaxQSOvEuhFctINI6ORGeW82EOIiXzaNKixjvueHxjcG7CO6WRaUUX9ADpx7NsfO6
         d6vbTk47aJl6vHFBVLDYncIPWzKOJlkku9e08TlUeOHZbO79Q0jK3h1GOv5lVhdTP9Y5
         CKXjGO4zm+dhcJmw8ahfejLmHK8SXv8u1pHqafKkkPhZXqyMxx8oBy41zs/cKuKXFz2t
         5PqkHlMDCop1M9jY69lggnR6qKwRFCj1zjD34On4Nd2bGdmoAVe7GKmuh413+aP3iMcP
         78pQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771189798; x=1771794598; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/cusOaB1RRkk5o1Oqtx1KMkhaZ63LZzGMA+5vMDafw=;
        b=QDfJiTXr0/K+A8RSEg0kYymchVMrQf+JEyAZ/2vCeH9nQ+Nd2mMo1i5xkKv0uG+xNR
         7YpKdjy1YouyyVieZQe7B9BDawC11SmJ9732Eg2UIDCnWqQUSw/XX5mI9SArdnL6WHgJ
         DYfJTYwmcLinAXzsKvk3zBjDCk7yGXYIU32SpUXKwe5jcMZKQDzcNx7UZBsbMzBlVT5U
         sm/rZgINZh07eiWfLvCLpX/RPrUP6pLi3NX9R//DVIE025QebXK8CU/q6wcR0mCKF6/I
         n+oXNw+M2MEANKt1KzIw4oZ/o/lKHh6uYuUdag6eMSZUNsvntUbX60ky0p3e7PqNU/3k
         MuVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771189798; x=1771794598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8/cusOaB1RRkk5o1Oqtx1KMkhaZ63LZzGMA+5vMDafw=;
        b=fO4/Z3kgqfhoH7UT27HJf4IRCZCUiQXC+8em74P8fEED7w9cysnEal/d+3x6DSbgX3
         wqtrkgvz59uvtWQz6MK2VbIW0LsbEl6VGYnMFapUSMqSucxJovQCqN56MJrNxeFaRgaI
         IqWTzw0BauqCak3tElTBEcwJBI2DJsMSl5Kk6w6FyNCK7nTI/jD574vYY1uamWb65Gke
         P8x38ZYKCXH+7k1fCpNauSGhA8jh1u8VuDTWo+pfOm/HHoWXEfxRdpF0ascoNltR0akm
         m8J+j0n2tLPWNMgK8gDRALK+fzN/s1oR6KfKXo0ESCjVjZfVgg0Fssbe5Yig74HWHS4c
         GNiA==
X-Forwarded-Encrypted: i=1; AJvYcCUWuFNdXmDYuBegKH2smY2vpRMBHU8unRakcjcPtLcIhoDcgE+n2udBd/tznY5oD3/0UCzaNfEskeBCdrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdVyCGd50RC1XSqYhL9MvxuPUSQkSWKwTwxVrDU1C6OM4mB/9W
	VuOVusPOUXfAJhLjndhg5kkSM8aydGCfsvFRqzTUSX3PH3bNqof4b2jVsRvEZ+tSDyAvhAoIXhA
	6iAmCn5N05NJsUBlLuJlF6YWtbN8I6hD9b+hg
X-Gm-Gg: AZuq6aJFOoKaPDtVzcwxolEpMZyId+MVgATiquOXdA1G93NQhSTA8oMT6Oy/5b41+HA
	CqdyhW7uKpUXdoq22+IgX217yH8tU/kGbTvYsV0Myiy3avJYlDL4BnyJEKa30DhMc8G8seJFVE6
	Ex5gbXyGcVw7mQ5y/NNIRhm6wtvntZ4lcfmskUqx+XzlFaxxUCnLaEGqfQO/k4PBDe55eOqSqJT
	VcRfcJrfPX3rdlxJxCk97hHRGUtBvojwuLCR3u+Ekdbh090woP1pAuURT6mD/WBv86kCvE0elOC
	HjI+z02umZQiE+g=
X-Received: by 2002:a05:690e:130b:b0:64a:e582:1df4 with SMTP id
 956f58d0204a3-64c14a7fd18mr6521389d50.2.1771189797555; Sun, 15 Feb 2026
 13:09:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260215124125.465162-2-thorsten.blum@linux.dev>
In-Reply-To: <20260215124125.465162-2-thorsten.blum@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Sun, 15 Feb 2026 22:09:21 +0100
X-Gm-Features: AZwV_QhxXP3Z3j7FNL3hjVM3mHfb2bVg8Ao95qmXJAI_nCBLpkmUpk6NpESx19A
Message-ID: <CAFXKEHbCrp57ruvCF2TXXcnoJF93Z5bdUd7Nt5WtM9_abtc66w@mail.gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix OTP sysfs read and error handling
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	stable@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten!

I tried to verify your patch on hardware today, unfortunately it did
not work for me.

My setup works with current atsha204a module in the below described way. Wh=
en
trying to dump the OTP zone on exactly the same hardware with a patched mod=
ule,
it only prints '0' and nothing more, see below.

Pls, let me know, if I'm doing something wrong; if my usage is wrong or
if my approach is somehow flaky. Otherwise, could you please have a second
look at it? Note, my patch at the time emerged from a particular
use-case at work, it's
likely that it's not covering all OTP. So, if incomplete, I'd really
appreciate having it fixed.

In the following I provide some details on what I did today.

8<-------------------------------------------------------------->8
My lab DUT hardware:
- RPi 3b+ with an ATSHA204A shield via i2c, 3.3V
- ATSHA204a with a locked config; initialized OTP zone with some values
- Just enough to be readable i.e. verify OTP content

My kernel source base, since on a RPi v6.19 branch, built w/ aarch64.
Note, I'm building the module then out-of-source with a separate .dtsi
(I'm not showing all the boiler-plate stuff here).
$ git remote -v
  origin  https://github.com/raspberrypi/linux (fetch)
  origin  https://github.com/raspberrypi/linux (push)
$ git log --oneline -3
  e150a7a6d683 (HEAD -> rpi-6.19.y, origin/rpi-6.19.y) configs: enable
Si5351 i2c common clock driver
  3c957f9e74de pcie-brcmstb: move the unilateral disable of CLKREQ#
before link-up
  994331c6ea59 drivers: media: pispbe: Add V4L2_PIX_FMT_NV12MT_COL128
format support

From the bootlog
  ...
  [    0.000000][    T0] Kernel command line: coherent_pool=3D1M
8250.nr_uarts=3D1 snd_bcm2835.enable_headphones=3D0 cgroup_disable=3Dmemory
   bcm2708_fb.fbwidth=3D720 bcm2708_fb.fbheight=3D480 bcm2708_fb.fbswap=3D1
vc_mem.mem_base=3D0x3ec00000 vc_mem.mem_size=3D0x40000000  dwc_otg
  .lpm_enable=3D0 console=3DttyAMA0,115200 console=3Dtty1
root=3D/dev/mmcblk0p2 rootfstype=3Dext4 elevator=3Ddeadline fsck.repair=3Dy=
es
rootwait
  [    0.000000][    T0] cgroup: Disabling memory control group subsystem
  [    0.000000][    T0] Kernel parameter elevator=3D does not have any
effect anymore.
  [    0.000000][    T0] Please use sysfs to set IO scheduler for
individual devices.
  [    0.000000][    T0] printk: log buffer data + meta data: 131072 +
458752 =3D 589824 bytes
  ...

...current atmel-sha204a:
root@dut02:~/atsha204a-orig# insmod atmel-i2c.ko
root@dut02:~/atsha204a-orig# insmod atmel-sha204a.ko
root@dut02:~/atsha204a-orig# cat /sys/bus/i2c/devices/1-0064/atsha204a/otp
0001ED86032D0002154C033750FFFFFF20B0F703DB0CFFFFFFFFFFFFFFFFFFFF

reboot...

...atmel-sha204a with patch applied:
root@dut02:~/atsha204a# modprobe i2c-dev
root@dut02:~/atsha204a# insmod ./atmel-i2c.ko
root@dut02:~/atsha204a# insmod ./atmel-sha204a.ko
root@dut02:~/atsha204a# cat /sys/bus/i2c/devices/1-0064/atsha204a/otp
0root@dut02:~/atsha204a#
root@dut02:~/atsha204a# xxd /sys/bus/i2c/devices/1-0064/atsha204a/otp
00000000: 30                                       0
8<-------------------------------------------------------------->8

Best,
L

On Sun, Feb 15, 2026 at 1:42=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Fix otp_show() to read and print all 64 bytes of the OTP zone.
> Previously, the loop only printed half of the OTP (32 bytes), and
> partial output was returned on read errors.
>
> Propagate the actual error from atmel_sha204a_otp_read() instead of
> producing partial output.
>
> Replace sprintf() with sysfs_emit_at(), which is preferred for
> formatting sysfs output because it provides safer bounds checking.
>
> Cc: stable@vger.kernel.org
> Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> ---
>  drivers/crypto/atmel-sha204a.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204=
a.c
> index 0fcf4a39de27..793c8d739a0a 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
> +#include <linux/sysfs.h>
>  #include <linux/workqueue.h>
>  #include "atmel-i2c.h"
>
> @@ -119,21 +120,21 @@ static ssize_t otp_show(struct device *dev,
>  {
>         u16 addr;
>         u8 otp[OTP_ZONE_SIZE];
> -       char *str =3D buf;
>         struct i2c_client *client =3D to_i2c_client(dev);
> -       int i;
> +       ssize_t len =3D 0;
> +       int i, ret;
>
> -       for (addr =3D 0; addr < OTP_ZONE_SIZE/4; addr++) {
> -               if (atmel_sha204a_otp_read(client, addr, otp + addr * 4) =
< 0) {
> +       for (addr =3D 0; addr < OTP_ZONE_SIZE / 4; addr++) {
> +               ret =3D atmel_sha204a_otp_read(client, addr, otp + addr *=
 4);
> +               if (ret < 0) {
>                         dev_err(dev, "failed to read otp zone\n");
> -                       break;
> +                       return ret;
>                 }
>         }
>
> -       for (i =3D 0; i < addr*2; i++)
> -               str +=3D sprintf(str, "%02X", otp[i]);
> -       str +=3D sprintf(str, "\n");
> -       return str - buf;
> +       for (i =3D 0; i < OTP_ZONE_SIZE; i++)
> +               len +=3D sysfs_emit_at(buf, len, "%02X", otp[i]);
> +       return sysfs_emit_at(buf, len, "\n");
>  }
>  static DEVICE_ATTR_RO(otp);
>
> --
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
>
