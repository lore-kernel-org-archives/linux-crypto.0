From: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Thu, 05 Jul 2018 10:02:01 -0700
Message-ID: <000000000000846e9e0570438176@google.com>
References: <3579823.yyIR4au8HA@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de, syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3579823.yyIR4au8HA@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

failed to checkout kernel repo https://github.com/google/kmsan.git/---:  
failed to run /usr/bin/git [git fetch https://github.com/google/kmsan.git  
---]: exit status 129
error: unknown option `-'
usage: git fetch [<options>] [<repository> [<refspec>...]]
    or: git fetch [<options>] <group>
    or: git fetch --multiple [<options>] [(<repository> | <group>)...]
    or: git fetch --all [<options>]

     -v, --verbose         be more verbose
     -q, --quiet           be more quiet
     --all                 fetch from all remotes
     -a, --append          append to .git/FETCH_HEAD instead of overwriting
     --upload-pack <path>  path to upload pack on remote end
     -f, --force           force overwrite of local branch
     -m, --multiple        fetch from multiple remotes
     -t, --tags            fetch all tags and associated objects
     -n                    do not fetch all tags (--no-tags)
     -p, --prune           prune remote-tracking branches no longer on remote
     --recurse-submodules[=<on-demand>]
                           control recursive fetching of submodules
     --dry-run             dry run
     -k, --keep            keep downloaded pack
     -u, --update-head-ok  allow updating of HEAD ref
     --progress            force progress reporting
     --depth <depth>       deepen history of shallow clone
     --unshallow           convert to a complete repository
     --update-shallow      accept refs that update .git/shallow
     --refmap <refmap>     specify fetch refmap




Tested on:

commit:         [unknown]
git tree:       https://github.com/google/kmsan.git/---
compiler:       clang version 7.0.0 (trunk 334104)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1207511c400000
