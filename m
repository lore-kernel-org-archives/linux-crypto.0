From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Fri, 6 Jul 2018 09:38:41 +0200
Message-ID: <CACT4Y+YJUVJnFt2bn7rhV+ET6dVhwWrym8DK+LgV3rJGVUuCFA@mail.gmail.com>
References: <000000000000846e9e0570438176@google.com> <1626520.Rx0128ICKU@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1626520.Rx0128ICKU@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 5, 2018 at 8:45 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Donnerstag, 5. Juli 2018, 19:02:01 CEST schrieb syzbot:
>
> Hi Dimitry,
>
> does the syzkaller somehow uses the "---" separator as part of the URL?

It used it as branch. Please see:

https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patc=
hes

for formats. In all formats a git tree is not enough. And it is not
enough to identify code state in any other context too, it's always
git repo + branch or commit hash.


>> syzbot tried to test the proposed patch but build/boot failed:
>>
>> failed to checkout kernel repo https://github.com/google/kmsan.git/---:
>> failed to run /usr/bin/git [git fetch https://github.com/google/kmsan.gi=
t
>> ---]: exit status 129
>> error: unknown option `-'
>> usage: git fetch [<options>] [<repository> [<refspec>...]]
>>     or: git fetch [<options>] <group>
>>     or: git fetch --multiple [<options>] [(<repository> | <group>)...]
>>     or: git fetch --all [<options>]
>>
>>      -v, --verbose         be more verbose
>>      -q, --quiet           be more quiet
>>      --all                 fetch from all remotes
>>      -a, --append          append to .git/FETCH_HEAD instead of overwrit=
ing
>>      --upload-pack <path>  path to upload pack on remote end
>>      -f, --force           force overwrite of local branch
>>      -m, --multiple        fetch from multiple remotes
>>      -t, --tags            fetch all tags and associated objects
>>      -n                    do not fetch all tags (--no-tags)
>>      -p, --prune           prune remote-tracking branches no longer on
>> remote --recurse-submodules[=3D<on-demand>]
>>                            control recursive fetching of submodules
>>      --dry-run             dry run
>>      -k, --keep            keep downloaded pack
>>      -u, --update-head-ok  allow updating of HEAD ref
>>      --progress            force progress reporting
>>      --depth <depth>       deepen history of shallow clone
>>      --unshallow           convert to a complete repository
>>      --update-shallow      accept refs that update .git/shallow
>>      --refmap <refmap>     specify fetch refmap
>>
>>
>>
>>
>> Tested on:
>>
>> commit:         [unknown]
>> git tree:       https://github.com/google/kmsan.git/---> compiler:      =
 clang version 7.0.0 (trunk 334104)
>> patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D1207511c4=
00000
>
>
> Ciao
> Stephan
>
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/1626520.Rx0128ICKU%40positron.chronox.de.
> For more options, visit https://groups.google.com/d/optout.
