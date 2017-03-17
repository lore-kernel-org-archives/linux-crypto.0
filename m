From: Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 6/7] md/raid10, LLVM: get rid of variable length array
Date: Fri, 17 Mar 2017 13:31:23 +0100
Message-ID: <CAG_fn=XcQLtcHRSm2BHYce9LMtyFJ+fWxfE4vYPCw+7U0DcrmQ@mail.gmail.com>
References: <20170317001520.85223-1-md@google.com> <20170317001520.85223-7-md@google.com>
 <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Michael Davidson <md@google.com>, Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170317120837.pr74cv3xuj7qpoin@hirez.programming.kicks-ass.net>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 17, 2017 at 1:08 PM, Peter Zijlstra <peterz@infradead.org> wrot=
e:
> On Thu, Mar 16, 2017 at 05:15:19PM -0700, Michael Davidson wrote:
>> Replace a variable length array in a struct by allocating
>> the memory for the entire struct in a char array on the stack.
>>
>> Signed-off-by: Michael Davidson <md@google.com>
>> ---
>>  drivers/md/raid10.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 063c43d83b72..158ebdff782c 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -4654,11 +4654,10 @@ static int handle_reshape_read_error(struct mdde=
v *mddev,
>>       /* Use sync reads to get the blocks from somewhere else */
>>       int sectors =3D r10_bio->sectors;
>>       struct r10conf *conf =3D mddev->private;
>> -     struct {
>> -             struct r10bio r10_bio;
>> -             struct r10dev devs[conf->copies];
>> -     } on_stack;
>> -     struct r10bio *r10b =3D &on_stack.r10_bio;
>> +     char on_stack_r10_bio[sizeof(struct r10bio) +
>> +                           conf->copies * sizeof(struct r10dev)]
>> +                           __aligned(__alignof__(struct r10bio));
>> +     struct r10bio *r10b =3D (struct r10bio *)on_stack_r10_bio;
>>       int slot =3D 0;
>>       int idx =3D 0;
>>       struct bio_vec *bvec =3D r10_bio->master_bio->bi_io_vec;
>
>
> That's disgusting. Why not fix LLVM to support this?

IIUC there's only a handful of VLAIS instances in LLVM code, why not
just drop them for the sake of better code portability?
(To quote Linus, "this feature is an abomination":
https://lkml.org/lkml/2013/9/23/500)

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Matthew Scott Sucherman, Paul Terence Manicle
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
