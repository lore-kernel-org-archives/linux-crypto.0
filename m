From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Sat, 12 Jan 2008 01:09:37 +0100
Message-ID: <20080112000937.GA23721@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc> <20080110154650.GA29453@one.firstfloor.org>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40910 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762157AbYALAJq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2008 19:09:46 -0500
Content-Disposition: inline
In-Reply-To: <20080110154650.GA29453@one.firstfloor.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Andi Kleen | 2008-01-10 16:46:50 [+0100]:

>On Thu, Jan 10, 2008 at 02:35:29PM +0100, Sebastian Siewior wrote:
>> * Herbert Xu | 2008-01-10 20:27:46 [+1100]:
>> 
>> >On Thu, Jan 10, 2008 at 10:25:55AM +0100, Andi Kleen wrote:
>> >>
>> >> Then I don't think the patch should have been applied.
>> >
>> >I disagree.  There isn't any evidence showing that the inlined version
>> >is significantly faster either.  In the absence of that, the version
>> >with the smaller size is preferable.
>> I tried to get rid of all those macros in AES and replace them with
>> static only. I noticed that this makes the implementation slower. The
>
>Yes not unexpected. These crypto functions tend to be carefully tuned
>(or at least their critical loops are) and changing inlines in carefully 
>tuned code is usually a bad idea.

While I was sitting in a train, I bench marked cast6 on my notebook, that's a
|bigeasy@kibibi /mnt/crypto/git/linux-2.6 $ cat /proc/cpuinfo 
|processor       : 0
|vendor_id       : GenuineIntel
|cpu family      : 6
|model           : 13
|model name      : Intel(R) Pentium(R) M processor 1.73GHz
|stepping        : 8
|cpu MHz         : 1733.000
|cache size      : 2048 KB
|fdiv_bug        : no
|hlt_bug         : no
|f00f_bug        : no
|coma_bug        : no
|fpu             : yes
|fpu_exception   : yes
|cpuid level     : 2
|wp              : yes
|flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
|mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
|bogomips        : 3463.18
|clflush size    : 64

on a 
|Linux kibibi 2.6.24-rc6 #2 Sat Jan 5 17:52:39 CET 2008 i686 Intel(R)
|Pentium(R) M processor 1.73GHz GenuineIntel GNU/Linux
with CONFIG_NO_HZ=y & CONFIG_HZ=100.

I created a crypto partition via
|cryptsetup create --cipher cast6 bench /dev/hda3
and used ext2 on it.

First run was write + inline. The module was
|cast6                  17216  0 

|bigeasy@kibibi /mnt/usb/l $ dd if=/dev/zero of=basilimi
|dd: writing to `basilimi': No space left on device
|1826865+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 49.1721 s, 19.0 MB/s

Then I run 'modprobe tcrypt mode=207' with a quick hack [1].
|testing speed of ecb(cast6) encryption
|test 0 (128 bit key, 16 byte blocks): 1 operation in 1049 cycles (16 bytes)
|test 1 (128 bit key, 64 byte blocks): 1 operation in 3398 cycles (64 bytes)
|test 2 (128 bit key, 256 byte blocks): 1 operation in 12828 cycles (256 bytes)
|test 3 (128 bit key, 1024 byte blocks): 1 operation in 50512 cycles (1024 bytes)
|test 4 (128 bit key, 8192 byte blocks): 1 operation in 403118 cycles (8192 bytes)
|test 5 (192 bit key, 16 byte blocks): 1 operation in 1045 cycles (16 bytes)
|test 6 (192 bit key, 64 byte blocks): 1 operation in 3397 cycles (64 bytes)
|test 7 (192 bit key, 256 byte blocks): 1 operation in 12828 cycles (256 bytes)
|test 8 (192 bit key, 1024 byte blocks): 1 operation in 50565 cycles (1024 bytes)
|test 9 (192 bit key, 8192 byte blocks): 1 operation in 406205 cycles (8192 bytes)
|test 10 (256 bit key, 16 byte blocks): 1 operation in 1044 cycles (16 bytes)
|test 11 (256 bit key, 64 byte blocks): 1 operation in 3399 cycles (64 bytes)
|test 12 (256 bit key, 256 byte blocks): 1 operation in 12834 cycles (256 bytes)
|test 13 (256 bit key, 1024 byte blocks): 1 operation in 50567 cycles (1024 bytes)
|test 14 (256 bit key, 8192 byte blocks): 1 operation in 403528 cycles (8192 bytes)
|
|testing speed of ecb(cast6) decryption
|test 0 (128 bit key, 16 byte blocks): 1 operation in 1044 cycles (16 bytes)
|test 1 (128 bit key, 64 byte blocks): 1 operation in 3419 cycles (64 bytes)
|test 2 (128 bit key, 256 byte blocks): 1 operation in 12865 cycles (256 bytes)
|test 3 (128 bit key, 1024 byte blocks): 1 operation in 50683 cycles (1024 bytes)
|test 4 (128 bit key, 8192 byte blocks): 1 operation in 404385 cycles (8192 bytes)
|test 5 (192 bit key, 16 byte blocks): 1 operation in 1043 cycles (16 bytes)
|test 6 (192 bit key, 64 byte blocks): 1 operation in 3419 cycles (64 bytes)
|test 7 (192 bit key, 256 byte blocks): 1 operation in 12866 cycles (256 bytes)
|test 8 (192 bit key, 1024 byte blocks): 1 operation in 50753 cycles (1024 bytes)
|test 9 (192 bit key, 8192 byte blocks): 1 operation in 407210 cycles (8192 bytes)
|test 10 (256 bit key, 16 byte blocks): 1 operation in 1043 cycles (16 bytes)
|test 11 (256 bit key, 64 byte blocks): 1 operation in 3419 cycles (64 bytes)
|test 12 (256 bit key, 256 byte blocks): 1 operation in 12863 cycles (256 bytes)
|test 13 (256 bit key, 1024 byte blocks): 1 operation in 50742 cycles (1024 bytes)
|test 14 (256 bit key, 8192 byte blocks): 1 operation in 404250 cycles (8192 bytes)

After that, I removed inline and tried again, the module shrank to
|cast6                   8704  0

Same procedure
|bigeasy@kibibi /mnt/usb/l $ dd if=/dev/zero of=basilimi
|dd: writing to `basilimi': No space left on device
|1826865+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.9814 s, 19.5 MB/s

and tcrypt
|testing speed of ecb(cast6) encryption
|test 0 (128 bit key, 16 byte blocks): 1 operation in 929 cycles (16 bytes)
|test 1 (128 bit key, 64 byte blocks): 1 operation in 2951 cycles (64 bytes)
|test 2 (128 bit key, 256 byte blocks): 1 operation in 11062 cycles (256 bytes)
|test 3 (128 bit key, 1024 byte blocks): 1 operation in 43509 cycles (1024 bytes)
|test 4 (128 bit key, 8192 byte blocks): 1 operation in 347532 cycles (8192 bytes)
|test 5 (192 bit key, 16 byte blocks): 1 operation in 926 cycles (16 bytes)
|test 6 (192 bit key, 64 byte blocks): 1 operation in 2947 cycles (64 bytes)
|test 7 (192 bit key, 256 byte blocks): 1 operation in 11064 cycles (256 bytes)
|test 8 (192 bit key, 1024 byte blocks): 1 operation in 43503 cycles (1024 bytes)
|test 9 (192 bit key, 8192 byte blocks): 1 operation in 350597 cycles (8192 bytes)
|test 10 (256 bit key, 16 byte blocks): 1 operation in 926 cycles (16 bytes)
|test 11 (256 bit key, 64 byte blocks): 1 operation in 2953 cycles (64 bytes)
|test 12 (256 bit key, 256 byte blocks): 1 operation in 11063 cycles (256 bytes)
|test 13 (256 bit key, 1024 byte blocks): 1 operation in 43489 cycles (1024 bytes)
|test 14 (256 bit key, 8192 byte blocks): 1 operation in 347208 cycles (8192 bytes)
|
|testing speed of ecb(cast6) decryption
|test 0 (128 bit key, 16 byte blocks): 1 operation in 927 cycles (16 bytes)
|test 1 (128 bit key, 64 byte blocks): 1 operation in 2953 cycles (64 bytes)
|test 2 (128 bit key, 256 byte blocks): 1 operation in 11073 cycles (256 bytes)
|test 3 (128 bit key, 1024 byte blocks): 1 operation in 43571 cycles (1024 bytes)
|test 4 (128 bit key, 8192 byte blocks): 1 operation in 347875 cycles (8192 bytes)
|test 5 (192 bit key, 16 byte blocks): 1 operation in 922 cycles (16 bytes)
|test 6 (192 bit key, 64 byte blocks): 1 operation in 2955 cycles (64 bytes)
|test 7 (192 bit key, 256 byte blocks): 1 operation in 11080 cycles (256 bytes)
|test 8 (192 bit key, 1024 byte blocks): 1 operation in 43622 cycles (1024 bytes)
|test 9 (192 bit key, 8192 byte blocks): 1 operation in 351189 cycles (8192 bytes)
|test 10 (256 bit key, 16 byte blocks): 1 operation in 923 cycles (16 bytes)
|test 11 (256 bit key, 64 byte blocks): 1 operation in 2954 cycles (64 bytes)
|test 12 (256 bit key, 256 byte blocks): 1 operation in 11080 cycles (256 bytes)
|test 13 (256 bit key, 1024 byte blocks): 1 operation in 43601 cycles (1024 bytes)
|test 14 (256 bit key, 8192 byte blocks): 1 operation in 348054 cycles (8192 bytes)

The dd performance is pretty close. Maybe my hd isn't that fast...
|kibibi linux-2.6 # hdparm -a 0 /dev/hda
|
|/dev/hda:
| setting fs readahead to 0
| readahead    =  0 (off)
|kibibi linux-2.6 # hdparm --direct -t /dev/hda
|
|/dev/hda:
| Timing O_DIRECT disk reads:  112 MB in  3.04 seconds =  36.87 MB/sec
|

Maybe it is. The same file but with read this time, first the inline edition
|bigeasy@kibibi /mnt/usb/l $ time dd of=/dev/null if=basilimi
|1826864+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.5538 s, 19.7 MB/s
|
|real    0m47.617s
|user    0m0.670s
|sys     0m4.560s
|bigeasy@kibibi /mnt/usb/l $ 

and now without:
|bigeasy@kibibi /mnt/usb/l $ dd of=/dev/null if=basilimi
|1826864+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.4728 s, 19.7 MB/s
|
|bigeasy@kibibi /mnt/usb/l $ time dd of=/dev/null if=basilimi
|1826864+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.9194 s, 19.5 MB/s
|
|real    0m47.948s
|user    0m0.760s
|sys     0m4.250s
|
|bigeasy@kibibi /mnt/usb/l $ time dd of=/dev/zero if=basilimi
|1826864+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.2979 s, 19.8 MB/s
|
|real    0m47.302s
|user    0m0.730s
|sys     0m4.540s
|bigeasy@kibibi /mnt/usb/l $ time dd of=/dev/zero if=basilimi
|1826864+0 records in
|1826864+0 records out
|935354368 bytes (935 MB) copied, 47.6229 s, 19.6 MB/s
|
|real    0m47.687s
|user    0m0.800s
|sys     0m4.230s
|bigeasy@kibibi /mnt/usb/l $ 

The inline and not inline performance is quite similar. I guess the
little difference here and there is due to some random ctx switches (I
had almost nothing running what includes an idle firefox on another
virtual desktop, wmnd & friends and fluxbox).
The tcrypt test which run without any kind of interruption performed
better on larger blocks and was even better on the smallest block.

Long story short, according to this numbers I'm all for the not inline
version.

[1]
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..a935abc 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1705,6 +1705,12 @@ static void do_test(void)
                test_cipher_speed("salsa20", ENCRYPT, sec, NULL, 0,
                                  salsa20_speed_template);
                break;
+       case 207:
+               test_cipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+                               camellia_speed_template);
+               test_cipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
+                               camellia_speed_template);
+               break;
 
        case 300:
                /* fall through */


>
>-Andi

Sebastian
