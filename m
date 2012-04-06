From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: RAID5 XOR speed vs RAID6 Q speed (was Re: AVX RAID5 xor checksumming)
Date: Fri, 6 Apr 2012 13:43:11 -0700
Message-ID: <CAA9_cmcE5BfZX2RwOpo=qng2_2wnvhm5dB-dBfjFGOUWiSy3fw@mail.gmail.com>
References: <4F7ACF94.5080505@anonymous.org.uk>
	<1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	bharrosh@panasas.com
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1333497379-2640-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[adding Boaz since he also made an attempt at fixing this]

http://marc.info/?l=3Dlinux-crypto-vger&m=3D131829241111450&w=3D2

=2E..I had meant to follow up on this, but was buried in 'isci' issues.


On Tue, Apr 3, 2012 at 4:56 PM, Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:
> On Tue, Apr 03, 2012 at 11:23:16AM +0100, John Robinson wrote:
>> On 02/04/2012 23:48, Jim Kukunas wrote:
>> > On Sat, Mar 31, 2012 at 12:38:56PM +0100, John Robinson wrote:
>> [...]
>> >> I just noticed in my logs the other day (recent el5 kernel on a C=
ore 2):
>> >>
>> >> raid5: automatically using best checksumming function: generic_ss=
e
>> >> =A0 =A0 =A0generic_sse: =A07805.000 MB/sec
>> >> raid5: using function: generic_sse (7805.000 MB/sec)
>> [...]
>> >> raid6: using algorithm sse2x4 (8237 MB/s)
>> >>
>> >> I was just wondering how it's possible to do the RAID6 Q calculat=
ion
>> >> faster than the RAID5 XOR calculation - or am I reading this log =
excerpt
>> >> wrongly?
>> >
>> > Out of curiosity, are you running with CONFIG_PREEMPT=3Dy?
>>
>> No. Here's an excerpt from my .config:
>>
>> # CONFIG_PREEMPT_NONE is not set
>> CONFIG_PREEMPT_VOLUNTARY=3Dy
>> # CONFIG_PREEMPT is not set
>> CONFIG_PREEMPT_BKL=3Dy
>> CONFIG_PREEMPT_NOTIFIERS=3Dy
>>
>> But this is a Xen dom0 kernel, 2.6.18-308.1.1.el5.centos.plusxen. No=
w, a
>> non-Xen kernel (2.6.18-308.1.1.el5) says:
>> raid5: automatically using best checksumming function: generic_sse
>> =A0 =A0 generic_sse: 11892.000 MB/sec
>> raid5: using function: generic_sse (11892.000 MB/sec)
>> raid6: int64x1 =A0 2644 MB/s
>> raid6: int64x2 =A0 3238 MB/s
>> raid6: int64x4 =A0 3011 MB/s
>> raid6: int64x8 =A0 2503 MB/s
>> raid6: sse2x1 =A0 =A05375 MB/s
>> raid6: sse2x2 =A0 =A05851 MB/s
>> raid6: sse2x4 =A0 =A09136 MB/s
>> raid6: using algorithm sse2x4 (9136 MB/s)
>>
>> Looks like it loses a chunk of performance running as a Xen dom0.
>>
>> Even still, 11892 MB/s for XOR vs 9136 MB/s for XOR+Q - it still see=
ms
>> remarkable that the XOR can't be done several times faster than the =
Q.
>
> Taking a look at do_xor_speed, I see two issues which might be the ca=
use
> of the disparity you reported.
>
> 0) In the RAID5 xor benchmark, we get the current jiffy, then run do_=
2() until
> the jiffy increments. This means we could potentially be testing for =
less
> than a full jiffy. The RAID6 benchmark handles this by obtaining the =
current
> jiffy, then calling cpu_relax() until the jiffy increments, and then =
running
> the test. This is addressed by my first patch.
>
> 1) The only way I could reproduce your findings of a higher throughpu=
t for
> RAID6 than for RAID5 xor checksumming was with CONFIG_PREEMPT=3Dy. It=
 seems
> that you encountered this while running as XEN dom0. Currently, we di=
sable
> preemption during the RAID6 benchmark, but don't in the RAID5 benchma=
rk.
> This is addressed by my second patch.
>
> I've added linux-crypto to the discussion as both of these patches af=
fect
> code in crypto/
>
> Thanks.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
