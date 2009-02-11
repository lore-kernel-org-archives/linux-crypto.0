From: Milan Broz <mbroz@redhat.com>
Subject: Re: Re: [Bugme-new] [Bug 12680] New: Not having a VIA
	PadLock hardware incurs a long delay in probing on modules insertion
	attempt.
Date: Wed, 11 Feb 2009 20:28:20 +0100
Message-ID: <499326D4.5060005@redhat.com>
References: <bug-12680-10286@http.bugzilla.kernel.org/>	<20090209130536.9a7a87cd.akpm@linux-foundation.org>	<4992FC7E.3010207@orange.fr>
	<20090211091647.6607aea4.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Valentin QUEQUET <v.quequet-techniques@orange.fr>,
	linux-crypto@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090211091647.6607aea4.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

Andrew Morton wrote:
> (cc dm-devel)
> 
> On Wed, 11 Feb 2009 17:27:42 +0100 Valentin QUEQUET <v.quequet-techniques@orange.fr> wrote:
> 
>> I've finally found why my computer seems to hang (pause) quite lengthy 
>> when I boot Pristine Linux 2.6.29-rcX... instead of Pristine Linux 
>> 2.6.28.4 (for example).
>>
>> The reason is that the cryptographic keys generation for the Device 
>> Mapper takes longer with 2.6.29 than with 2.6.28 under certain 
>> circumstances.
> 
> So it's device-mapper userspace?

No. cryptsetup (which is probably "device-mapper userspace" here) reads
/dev/random only during luksFormat or during manipulating with keyslots
(adding key for example).

The situation you are talking about is when you have for example swap
encrypted with random key. It is initscripts which owns /etc/crypttab
and which just tell cryptsetup "use /dev/random as keyfile".

Also initscripts are responsible for loading of random seed to 
properly initialize RNG *before* this.

Most distributions uses two steps - mount volume with /var
(where is the random seed stored) and later mount encrypted volumes
using random key.

I do not know if the delay in new kernel is bug, but the problem
with lack of entropy during system boot is "known" problem.
(Imagine 128bit random key which use fast-generated key with only
few random bits because of lack of entropy... better to not
use encryption at all then use such key!)

(if you use LUKS, the random key is generated during luksFormat and
you do not need random data (entropy) on activation, you just need
enter known passphrase to unlock keyslot with the volume key.)

Milan
--
mbroz@redhat.com
